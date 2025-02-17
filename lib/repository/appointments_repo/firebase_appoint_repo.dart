import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hair_salon/models/models.dart';
import 'package:hair_salon/repository/appointments_repo/appointment_repo.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/repository/notifications/notification_services.dart';

class FirebaseAppointmentRepository implements IAppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authService = FirebaseAuthRepository();

  FirebaseAppointmentRepository();

  @override
  Future<List<Appointment>> fetchAppointments() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('appointments').get();
      return snapshot.docs.map((doc) {
        return Appointment.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('error_fetching_appointments'.tr, '$e');
      rethrow;
    }
  }

  Future<bool> checkSlotAvailability({
    required String specialistUid,
    required DateTime selectedDate,
    required String selectedTime,
    String? appointmentId, // Make this optional
  }) async {
    try {
      final normalizedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      final querySnapshot = await _firestore
          .collection('appointments')
          .where('specialistUid', isEqualTo: specialistUid)
          .where('time', isEqualTo: selectedTime)
          .get();

      final conflictingAppointments = querySnapshot.docs.where((doc) {
        final appointmentDate = (doc['date'] as Timestamp).toDate();
        final normalizedAppointmentDate = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
        );

        // Skip conflict check if it's the same appointment (only for editing)
        if (appointmentId != null && doc.id == appointmentId) {
          return false;
        }

        return normalizedAppointmentDate.isAtSameMomentAs(normalizedDate);
      }).toList();

      return conflictingAppointments.isEmpty;
    } catch (error) {
      throw Exception('failed_to_check_slot_availability'.tr);
    }
  }

  @override
  Future<void> moveAppointmentToCancelAppointments(
      Appointment appointment) async {
    try {
      final userDetails = await _authService.fetchUserDetails();

      final Map<String, dynamic> appointmentData = {
        'userName': userDetails!['name'],
        'phoneNumber': userDetails['phone'],
        'birthday': userDetails['birthday'],
        'gender': userDetails['gender'],
        'specialistUid': appointment.specialistUid,
        'specialistName': appointment.stylist,
        'userUid': appointment.userUid,
        'date': Timestamp.fromDate(appointment.date),
        'time': appointment.time,
        'recurring': appointment.recurring,
        'treatment': appointment.appointmentFor,
        'duration': appointment.duration,
        'isCancelled': true,
        'charges': appointment.charges.toDouble(),
        'notificationTime': appointment.notificationTime.toIso8601String(),
        'createdAt': Timestamp.now(),
        'serviceImageUrl': appointment.serviceImageUrl,
        'isUpComing': appointment.isUpComing,
        'isWaiting': appointment.isWaiting,
        'id': appointment.id, // Retain original ID
      };

      // Add the document to `cancel_appointments` with the same ID
      await _firestore
          .collection('cancel_appointments')
          .doc(appointment.id)
          .set(appointmentData);

      // Remove the document from `appointments`
      await _firestore.collection('appointments').doc(appointment.id).delete();
    } catch (error) {
      throw Exception('failed_to_move_appointment_to_cancel_appointments'.tr);
    }
  }

  @override
  Future<void> moveAppointmentToCancel(Appointment appointment) async {
    try {
      final userDetails = await _authService.fetchUserDetails();

      final Map<String, dynamic> appointmentData = {
        'userName': userDetails!['name'],
        'phoneNumber': userDetails['phone'],
        'birthday': userDetails['birthday'],
        'gender': userDetails['gender'],
        'specialistUid': appointment.specialistUid,
        'specialistName': appointment.stylist,
        'userUid': appointment.userUid,
        'date': Timestamp.fromDate(appointment.date),
        'time': appointment.time,
        'recurring': appointment.recurring,
        'treatment': appointment.appointmentFor,
        'duration': appointment.duration,
        'isCancelled': true,
        'charges': appointment.charges.toDouble(),
        'notificationTime': appointment.notificationTime.toIso8601String(),
        'createdAt': Timestamp.now(),
        'serviceImageUrl': appointment.serviceImageUrl,
        'isUpComing': appointment.isUpComing,
        'isWaiting': appointment.isWaiting,
        'id': appointment.id, // Retain original ID
      };

      // Add the document to `cancel_appointments` with the same ID
      await _firestore
          .collection('cancel_appointments')
          .doc(appointment.id)
          .set(appointmentData);
    } catch (error) {
      throw Exception('failed_to_save_appointment'.tr);
    }
  }

  @override
  Future<void> saveAppointment(Appointment appointment) async {
    try {
      final userDetails = await _authService.fetchUserDetails();

      final Map<String, dynamic> appointmentData = {
        'userName': userDetails!['name'],
        'phoneNumber': userDetails['phone'],
        'birthday': userDetails['birthday'],
        'gender': userDetails['gender'],
        'specialistUid': appointment.specialistUid,
        'specialistName': appointment.stylist,
        'userUid': appointment.userUid,
        'date': Timestamp.fromDate(appointment.date),
        'time': appointment.time,
        'recurring': appointment.recurring,
        'treatment': appointment.appointmentFor,
        'duration': appointment.duration,
        'isCancelled': appointment.isCancelled,
        'charges': appointment.charges.toDouble(),
        'notificationTime': appointment.notificationTime.toIso8601String(),
        'createdAt': Timestamp.now(),
        'serviceImageUrl': appointment.serviceImageUrl,
        'isUpComing': appointment.isUpComing,
        'isWaiting': appointment.isWaiting,
      };

      final docRef =
          await _firestore.collection('appointments').add(appointmentData);

      await _firestore.collection('appointments').doc(docRef.id).update({
        'id': docRef.id,
      });

      final NotificationService notificationService = NotificationService();

      // Calculate delay before the notification time
      final notificationTime = appointment.notificationTime;
      final currentTime = DateTime.now();
      final delay = notificationTime.isAfter(currentTime)
          ? notificationTime.difference(currentTime).inMilliseconds
          : 0; // If the notification time is in the past, send immediately

      if (delay > 0) {
        // If the delay is positive, schedule the notification
        Future.delayed(Duration(milliseconds: delay), () async {
          // Send the notification first
          await notificationService.simulateScheduledNotification(
            title: 'appointment_reminder'.tr,
            body: 'appointment_reminder_body'.tr,
            scheduledTime: appointment.notificationTime,
          );

          // Save the notification once it's shown to the user
          await saveNotification(
            title: 'appointment_reminder'.tr,
            body: 'appointment_reminder_body'.tr,
            scheduledTime: appointment.notificationTime,
            userUid: appointment.userUid,
          );
        });
      } else {
        // If the notification time is already passed, send it immediately
        await notificationService.simulateScheduledNotification(
          title: 'appointment_reminder'.tr,
          body: 'appointment_reminder_body'.tr,
          scheduledTime: appointment.notificationTime,
        );

        // Save the notification immediately after sending it
        await saveNotification(
          title: 'appointment_reminder'.tr,
          body: 'appointment_reminder_body'.tr,
          scheduledTime: appointment.notificationTime,
          userUid: appointment.userUid,
        );
      }

      final timeParts = appointment.time.split(RegExp(r'[: ]'));
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      final DateTime startDateTime = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
        hour, // Extract the hour from the appointment time
        minute, // Extract the minute from the appointment time
      );
      final DateTime endDateTime = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
        hour, // Extract the hour from the appointment time
        minute, // Extract the minute from the appointment time
      );

      final Event calendarEvent = Event(
        title: 'Appointment with ${appointment.stylist}',
        description: 'Treatment: ${appointment.appointmentFor}',
        location: 'Specialist Address (if applicable)',
        startDate: startDateTime,
        endDate: endDateTime,
        iosParams: const IOSParams(
          reminder: Duration(minutes: 120),
        ),
        androidParams: const AndroidParams(
          emailInvites: [],
        ),
      );

      await Add2Calendar.addEvent2Cal(calendarEvent);
    } catch (error) {
      throw Exception('failed_to_save_appointment'.tr);
    }
  }

  @override
  DateTime calculateNotificationTime(
      DateTime appointmentDate, String appointmentTime) {
    final timeParts = appointmentTime.split(":");
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(" ")[0]);
    final isPM = appointmentTime.toLowerCase().contains("pm");

    final hour24 =
        isPM && hour != 12 ? hour + 12 : (hour == 12 && !isPM ? 0 : hour);
    final fullAppointmentTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      hour24,
      minute,
    );

    return fullAppointmentTime.subtract(const Duration(hours: 2));
  }

  @override
  Future<void> addToWaitingList(Appointment appointment,
      {required DateTime createdAt}) async {
    try {
      final data = appointment.toMap();
      final FirebaseAuthRepository authService = FirebaseAuthRepository();
      data['createdAt'] = Timestamp.fromDate(createdAt);

      final userDetails = await authService.fetchUserDetails();

      final docRef =
          await FirebaseFirestore.instance.collection('waitinglist').add(data);

      await docRef.update({'id': docRef.id, 'userName': userDetails!['name']});

      Get.snackbar(
        'success'.tr,
        'added_to_waiting_list_successfully'.tr,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_add_to_waiting_list'.trParams({'error': e.toString()}),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> saveNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String userUid,
  }) async {
    try {
      final notificationData = {
        'title': title,
        'body': body,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'userUid': userUid,
        'createdAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);
    } catch (e) {}
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final appointmentDoc =
          await _firestore.collection('appointments').doc(appointmentId).get();

      if (!appointmentDoc.exists) {
        Get.snackbar('error'.tr, 'appointment_not_found'.tr);
        return;
      }

      // Update the `isCancelled` field to true
      await _firestore.collection('appointments').doc(appointmentId).update({
        'isCancelled': true,
      });

      Get.snackbar('success'.tr, 'appointment_cancelled_successfully'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'error_cancelling_appointment'.tr);
      rethrow;
    }
  }

  @override
  Future<void> cancelAppointmentFromWaitingList(Appointment appointment) async {
    try {
      // Fetch the appointment document
      final appointmentDoc =
          await _firestore.collection('waitinglist').doc(appointment.id).get();

      // Check if the document exists
      if (!appointmentDoc.exists) {
        Get.snackbar('error'.tr, 'appointment_not_found'.tr);
        return;
      }

      // Delete the document from Firestore
      await _firestore.collection('waitinglist').doc(appointment.id).delete();
      await moveAppointmentToCancelAppointments(appointment);
      // Notify the user of successful deletion
      Get.snackbar('success'.tr, 'appointment_cancelled_successfully'.tr);
    } catch (e) {
      // Handle any errors that occur
      Get.snackbar('error'.tr, 'error_cancelling_appointment'.tr);
      rethrow; // Re-throw the error for further handling if needed
    }
  }

  @override
  Future<void> cancelAllAppointments(String specialistUid) async {
    try {
      // Get all appointments associated with the specialistUid
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('specialistUid', isEqualTo: specialistUid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Get.snackbar('error'.tr, 'no_appointments_found_for_specialist'.tr);
        return;
      }

      // Cancel each appointment
      for (final doc in querySnapshot.docs) {
        await _firestore.collection('appointments').doc(doc.id).delete();
      }

      for (final doc in querySnapshot.docs) {
        final docRef =
            await _firestore.collection('cancel_appointments').add(doc.data());

        await _firestore
            .collection('cancel_appointments')
            .doc(docRef.id)
            .update({
          'id': docRef.id,
        });
      }

      Get.snackbar('success'.tr, 'all_appointments_cancelled_successfully'.tr);
    } catch (e) {
      Get.snackbar('error_cancelling_appointments'.tr, '$e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      final appointmentDoc =
          await _firestore.collection('appointments').doc(appointmentId).get();

      if (!appointmentDoc.exists) {
        Get.snackbar('error'.tr, 'appointment_not_found'.tr);
        return;
      }

      final appointmentData = appointmentDoc.data() as Map<String, dynamic>;
      final specialistUid = appointmentData['specialistUid'];

      await _firestore.collection('appointments').doc(appointmentId).delete();

      await _promoteWaitingListUser(specialistUid);
      Get.snackbar('success'.tr, 'appointment_deleted_successfully'.tr);
    } catch (e) {
      Get.snackbar('error_deleting_appointment'.tr, '$e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAppointmentAndMoveToCancel(Appointment appointment) async {
    try {
      final appointmentDoc =
          await _firestore.collection('appointments').doc(appointment.id).get();

      if (!appointmentDoc.exists) {
        Get.snackbar('error'.tr, 'appointment_not_found'.tr);
        return;
      }

      final appointmentData = appointmentDoc.data() as Map<String, dynamic>;
      final specialistUid = appointmentData['specialistUid'];

      await _firestore.collection('appointments').doc(appointment.id).delete();

      await _promoteWaitingListUser(specialistUid);
      await moveAppointmentToCancel(appointment);
      Get.snackbar('success'.tr, 'appointment_cancelled_successfully'.tr);
    } catch (e) {
      Get.snackbar('error_deleting_appointment'.tr, '$e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAllAppointmentsForSpecificStaff(
      List<Appointment> appointments) async {
    try {
      final querySnapshot = await _firestore.collection('appointments').get();

      if (querySnapshot.docs.isEmpty) {
        Get.snackbar('info'.tr, 'no_appointments_found_to_delete'.tr);
        return;
      }

      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      Get.snackbar('success'.tr, 'all_appointments_deleted_successfully'.tr);
    } catch (e) {
      Get.snackbar('error_deleting_appointments'.tr, '$e');
      rethrow;
    }
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    try {
      final userDetails = await _authService.fetchUserDetails();
      final Map<String, dynamic> updatedAppointmentData = {
        'userName': userDetails!['name'],
        'phoneNumber': userDetails['phone'],
        'birthday': userDetails['birthday'],
        'gender': userDetails['gender'],
        'specialistUid': appointment.specialistUid,
        'specialistName': appointment.stylist,
        'userUid': appointment.userUid,
        'date': Timestamp.fromDate(appointment.date),
        'time': appointment.time,
        'recurring': appointment.recurring,
        'treatment': appointment.appointmentFor,
        'duration': appointment.duration,
        'charges': appointment.charges.toDouble(),
        'notificationTime': appointment.notificationTime.toIso8601String(),
        'createdAt': Timestamp.now(),
        'serviceImageUrl': appointment.serviceImageUrl,
        'isUpComing': appointment.isUpComing,
        'isCancelled': false,
        'isWaiting': appointment.isWaiting,
      };

      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .update(updatedAppointmentData);

      final NotificationService notificationService = NotificationService();
      await notificationService.simulateScheduledNotification(
        title: 'appointment_reminder'.tr,
        body: 'appointment_reminder_body'.tr,
        scheduledTime: appointment.notificationTime,
      );

      await saveNotification(
        title: 'appointment_reminder'.tr,
        body: 'appointment_reminder_body'.tr,
        scheduledTime: appointment.notificationTime,
        userUid: appointment.userUid,
      );
    } catch (e) {
      throw Exception('failed_to_update_appointment'.tr);
    }
  }

  Future<void> rebookAppointment(Appointment appointment) async {
    final userDetails = await _authService.fetchUserDetails();

    try {
      // Updated appointment data map
      final Map<String, dynamic> updatedAppointmentData = {
        'userName': userDetails!['name'],
        'phoneNumber': userDetails['phone'],
        'birthday': userDetails['birthday'],
        'gender': userDetails['gender'],
        'specialistUid': appointment.specialistUid,
        'specialistName': appointment.stylist,
        'userUid': appointment.userUid,
        'date': Timestamp.fromDate(appointment.date),
        'time': appointment.time,
        'recurring': appointment.recurring,
        'treatment': appointment.appointmentFor,
        'duration': appointment.duration,
        'charges': appointment.charges.toDouble(),
        'notificationTime': appointment.notificationTime.toIso8601String(),
        'createdAt': Timestamp.now(),
        'serviceImageUrl': appointment.serviceImageUrl,
        'isUpComing': appointment.isUpComing,
        'isCancelled': false, // Set to false since it's being rebooked
        'isWaiting': appointment.isWaiting,
        'id': appointment.id, // Ensure the same ID is used
      };

      // Move the appointment back to `appointments` collection
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(updatedAppointmentData);

      // Remove it from `cancel_appointments`
      await _firestore
          .collection('cancel_appointments')
          .doc(appointment.id)
          .delete();
    } catch (e) {
      throw Exception('failed_to_rebook_appointment'.tr);
    }
  }

  Future<void> _promoteWaitingListUser(String specialistUid) async {
    try {
      final waitingListSnapshot = await _firestore
          .collection('waitinglist')
          .where('specialistUid', isEqualTo: specialistUid)
          .orderBy('createdAt')
          .limit(1)
          .get();

      if (waitingListSnapshot.docs.isEmpty) {
        return;
      }

      final topWaitingUser = waitingListSnapshot.docs.first;
      final waitingUserData = topWaitingUser.data();

      DateTime promotedDate = DateTime.now();
      String promotedTime = '10:00 AM';
      if (waitingUserData['date'] != null && waitingUserData['time'] != null) {
        promotedDate = (waitingUserData['date'] as Timestamp).toDate();
        promotedTime = waitingUserData['time'] as String;
      }

      double charges = waitingUserData['charges'] is int
          ? (waitingUserData['charges'] as int).toDouble()
          : (waitingUserData['charges'] as double);

      final newAppointmentData = {
        'userUid': waitingUserData['userUid'],
        'userName': waitingUserData['userName'],
        'phoneNumber': waitingUserData['phoneNumber'],
        'gender': waitingUserData['gender'],
        'birthday': waitingUserData['birthday'],
        'specialistUid': specialistUid,
        'specialistName': waitingUserData['specialistName'],
        'date': Timestamp.fromDate(promotedDate),
        'time': promotedTime,
        'charges': charges,
        'treatment': waitingUserData['treatment'],
        'duration': waitingUserData['duration'],
        'notificationTime': DateTime.now().toIso8601String(),
        'isUpComing': true,
        'isWaiting': false,
        'createdAt': Timestamp.now(),
        'id': topWaitingUser.id,
      };

      await _firestore
          .collection('appointments')
          .doc(topWaitingUser.id)
          .set(newAppointmentData);

      await saveNotification(
        title: 'appointment_promotion'.tr,
        body: 'appointment_promotion_body'.trParams({
          'date': promotedDate.toLocal().toString().split(' ')[0],
          'time': promotedTime,
        }),
        scheduledTime: DateTime.now(),
        userUid: waitingUserData['userUid'],
      );

      await _firestore
          .collection('waitinglist')
          .doc(topWaitingUser.id)
          .delete();
    } catch (e) {
      Get.snackbar('error'.tr, 'message: $e');
    }
  }
}
