const { onDocumentDeleted, onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

// Handle Appointment Cancellation
exports.handleAppointmentCancellation = onDocumentDeleted(
  "appointments/{appointmentId}",
  async (event) => {
    const canceledAppointmentSnapshot = event.data;

    if (!canceledAppointmentSnapshot) {
      console.error("No appointment data available.");
      return null;
    }

    try {
      const canceledAppointment = canceledAppointmentSnapshot.data();
      if (!canceledAppointment) {
        console.error("No data found in canceledAppointmentSnapshot.");
        return null;
      }

      const specialistUid = canceledAppointment.specialistUid;
      if (!specialistUid) {
        console.error("specialistUid is undefined or null.");
        return null;
      }

      // Fetch the top waiting list entry for this specialist
      const waitingListSnapshot = await db
        .collection("waitinglist")
        .where("specialistUid", "==", specialistUid)
        .orderBy("createdAt")
        .limit(1)
        .get();

      if (waitingListSnapshot.empty) {
        console.log("No users in the waiting list for this specialist.");
        return null;
      }

      const topWaitingUserDoc = waitingListSnapshot.docs[0];
      const topWaitingUser = topWaitingUserDoc.data();

      // Create a new appointment for the waiting list user
      const newAppointmentData = {
        ...canceledAppointment,

        userUid: topWaitingUser.userUid,
        userName: topWaitingUser.userName,
        phoneNumber: topWaitingUser.phoneNumber,
        gender: topWaitingUser.gender,
        birthday: topWaitingUser.birthday,
        id:topWaitingUserDoc.id,
        createdAt: admin.firestore.Timestamp.now(),
      };

      await db
      .collection("appointments")
      .doc(topWaitingUserDoc.id) // Explicitly set the document ID
      .set(newAppointmentData);
    console.log(`New appointment created for user: ${topWaitingUser.userUid}`);

      // Notify the promoted user
      await db.collection("notifications").add({
        title: "Appointment Promotion",
        body: `You have been promoted from the waiting list! Your appointment is on ${new Date(
          canceledAppointment.date._seconds * 1000
        ).toLocaleDateString()} at ${canceledAppointment.time}.`,
        userUid: topWaitingUser.userUid,
        createdAt: admin.firestore.Timestamp.now(),
        scheduledTime: admin.firestore.Timestamp.now(), // Immediate notification

      });
      
      console.log(`Notification sent to user: ${topWaitingUser.userUid}`);
      await sendNotification(
        "Appointment Promotion",
        `You have been promoted from the waiting list! Your appointment is on ${new Date(
          canceledAppointment.date._seconds * 1000
        ).toLocaleDateString()} at ${canceledAppointment.time}.`,
        topWaitingUser.deviceToken, // Pass the user's device token
        {
          appointmentId: topWaitingUserDoc.id,
          specialistUid: specialistUid,
        }
      );
      
      // Remove the user from the waiting list
      await topWaitingUserDoc.ref.delete();
      console.log(`User removed from waiting list: ${topWaitingUser.userUid}`);
    } catch (error) {
      console.error("Error handling appointment cancellation:", error);
    }
  }
);

// Handle Recurring Appointments - Runs Daily
// Handle Recurring Appointments - Runs Daily
exports.handleRecurringAppointments = onSchedule("every 24 hours", async (context) => {
  const currentDate = new Date();

  try {
    const snapshot = await db
      .collection("appointments")
      .where("recurring.isRecurring", "==", true)
      .get();

    if (snapshot.empty) {
      console.log("No recurring appointments found.");
      return null;
    }

    for (const doc of snapshot.docs) {
      const appointment = doc.data();
      const appointmentDate = appointment.date.toDate();
      let newDate;

      switch (appointment.recurring.frequency) {
        case "Weekly" || 'שבועי':
          newDate = new Date(appointmentDate);
          newDate.setDate(appointmentDate.getDate() + 7); // Add 7 days for weekly
          break;

        case "Monthly" || 'חודשי':
          newDate = new Date(appointmentDate);
          newDate.setMonth(appointmentDate.getMonth() + 1); // Add 1 month for monthly
          break;

        case "Yearly" || 'שנתי':
          newDate = new Date(appointmentDate);
          newDate.setFullYear(appointmentDate.getFullYear() + 1); // Add 1 year for yearly
          break;

        default:
          console.log(`Unknown frequency: ${appointment.recurring.frequency}`);
          continue;
      }

      // Skip outdated recurring appointments
      if (newDate <= currentDate) {
        console.log("Skipping outdated recurring appointment.");
        continue;
      }

      const newAppointmentData = {
        ...appointment,
        date: admin.firestore.Timestamp.fromDate(newDate),
        notificationTime: admin.firestore.Timestamp.fromDate(
          new Date(newDate.getTime() - 2 * 60 * 60 * 1000) // Notify 2 hours before
        ),
        createdAt: admin.firestore.Timestamp.now(),
      };

      // Remove the ID for the new appointment
      delete newAppointmentData.id;

      const newDocRef = await db.collection("appointments").add(newAppointmentData);
      console.log(`Recurring appointment created: ${newDocRef.id}`);

      await db.collection("notifications").add({
        title: "Recurring Appointment Created",
        body: `Your ${appointment.recurring.frequency} appointment has been created for ${newDate.toDateString()} at ${appointment.time}.`,
        userUid: appointment.userUid,
        createdAt: admin.firestore.Timestamp.now(),
        scheduledTime: newAppointmentData.notificationTime,
      });

      await sendNotification(
        "Recurring Appointment Created",
        `Your ${appointment.recurring.frequency} appointment has been created for ${newDate.toDateString()} at ${appointment.time}.`,
        appointment.deviceToken, // Pass the user's device token
        {
          recurringId: doc.id,
          nextDate: newDate.toISOString(),
        }
      );
      
      console.log(`Notification added for user: ${appointment.userUid}`);
    }
  } catch (error) {
    console.error("Error handling recurring appointments:", error);
  }
});


exports.sendBroadcastNotification = onDocumentCreated(
  "broadcastMessages/{messageId}",
  async (event) => {
    const messageData = event.data.data();

    if (!messageData) {
      console.error("No data found in broadcast message.");
      return;
    }

    const title = messageData.title;
    const body = messageData.body;

    try {
      // Fetch all device tokens
      const usersSnapshot = await db.collection("users").get();

      const tokens = [];
      usersSnapshot.forEach((doc) => {
        const data = doc.data();
        if (data.deviceToken) {
          tokens.push(data.deviceToken);
        }
      });

      if (tokens.length === 0) {
        console.log("No device tokens found.");
        return;
      }

      // Split tokens into batches of 500
      const tokenChunks = [];
      for (let i = 0; i < tokens.length; i += 500) {
        tokenChunks.push(tokens.slice(i, i + 500));
      }

      // Send notification to each batch of tokens
    
      const sendPromises = tokenChunks.map((chunk) =>
        chunk.map((token) =>
          sendNotification(
            title,
            body,
            token, // Pass each user's token
            { broadcastId: event.params.messageId }
          )
        )
      );
      await Promise.all(sendPromises);
      

      const responses = await Promise.all(sendPromises);

      let successCount = 0;
      let failureCount = 0;
      responses.forEach((response) => {
        successCount += response.successCount;
        failureCount += response.failureCount;
      });

      console.log(`${successCount} messages sent successfully.`);
      console.log(`${failureCount} messages failed.`);

      if (failureCount > 0) {
        console.error("Some messages failed to send. Check logs for details.");
      }
    } catch (error) {
      console.error("Error sending broadcast notifications:", error);
    }
  }
);
exports.scheduleAppointmentNotification = onDocumentCreated(
  "appointments/{appointmentId}",
  async (event) => {
    const appointment = event.data.data();

    if (!appointment || !appointment.date || !appointment.time || !appointment.userUid) {
      console.error("Invalid appointment data.");
      return;
    }

    try {
      const userUid = appointment.userUid;

      // Parse the appointment date
      let appointmentDate;
      if (appointment.date.toDate) {
        // Firestore Timestamp
        appointmentDate = appointment.date.toDate();
      } else {
        // Assume ISO 8601 string
        appointmentDate = new Date(appointment.date);
      }

      if (isNaN(appointmentDate)) {
        console.error("Failed to parse the appointment date.");
        return;
      }

      console.log("Complete appointment date and time (UTC):", appointmentDate.toUTCString());

      // Parse the appointment time
      const timeMatch = appointment.time.match(/(\d+):(\d+)\s?(AM|PM)/i);
      if (!timeMatch) {
        console.error("Invalid time format:", appointment.time);
        return;
      }

      const [, hour, minute, period] = timeMatch;
      const appointmentHour = period.toUpperCase() === "PM" && hour !== "12" ? +hour + 12 : +hour === 12 && period.toUpperCase() === "AM" ? 0 : +hour;

      // Set the parsed time on the appointment date
      appointmentDate.setHours(appointmentHour, +minute, 0, 0);

      console.log("Complete appointment date and time (UTC):", appointmentDate.toUTCString());

      // Calculate the notification time (2 hours before the appointment)
      const notificationTime = new Date(appointmentDate.getTime() - 2 * 60 * 60 * 1000); // 2 hours in milliseconds
      const currentTime = new Date();

      console.log("Notification time (UTC):", notificationTime.toUTCString());
      console.log("Current time (UTC):", currentTime.toUTCString());

      const delay = notificationTime - currentTime; // Delay in milliseconds

      if (delay > 0) {
        // Schedule the notification
        console.log(`Scheduling notification for: ${notificationTime.toUTCString()}`);

        setTimeout(async () => {
          try {
            console.log("Sending scheduled notification at:", new Date().toUTCString());

            const notificationData = {
              title: "Appointment Reminder",
              body: "Your appointment is in 2 hours!",
              scheduledTime: notificationTime.toString(),
              userUid: userUid,
              isRead: false,
              createdAt: admin.firestore.Timestamp.now(),
            };

            // Fetch the user's device token
            const userSnapshot = await db.collection("users").doc(userUid).get();
            const userData = userSnapshot.data();

            if (!userData || !userData.deviceToken) {
              console.error("No device token found for user.");
              return;
            }

            const deviceToken = userData.deviceToken;

            // Send the notification
            await sendNotification(notificationData.title, notificationData.body, deviceToken, {
              appointmentId: event.params.appointmentId,
            });

            // Save the notification to Firestore
            await db.collection("notifications").add(notificationData);
            console.log("Notification saved to Firestore after successful delivery.");
          } catch (error) {
            console.error("Error sending scheduled notification:", error);
          }
        }, delay);
      } else {
        console.log("Notification time is in the past, skipping scheduling.");
      }
    } catch (error) {
      console.error("Error scheduling appointment notification:", error);
    }
  }
);

const messaging = admin.messaging();

/**
 * Helper function to send notifications
 * @param {string} title - Notification title
 * @param {string} body - Notification body
 * @param {string} token - Device token
 * @param {Object} [data] - Optional additional data for the notification
 */
async function sendNotification(title, body, token, data = {}) {
  try {
    const payload = {
      token: token,
      notification: {
        title: title,
        body: body,
      },
      android: {
        priority: "high",
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
            alert: {
              title: title,
              body: body,
            },
          },
        },
      },
      data: data,
    };

    await messaging.send(payload);
    console.log(`Notification sent: ${title}`);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
}
