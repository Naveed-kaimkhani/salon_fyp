// import 'package:cloud_firestore/cloud_firestore.dart';

// class Appointment {
//   final DateTime date;
//   final String time;
//   final String stylist; // Display name of the stylist
//   final String specialistUid; // Unique ID of the stylist
//   final String userUid; // Unique ID of the user
//   final String duration;
//   final String charges;
//   final String appointmentFor;
//   final bool isUpComing;
//   static const bool isRemindMe = false;
//   final bool isWaiting;
//   final String gender; // Added field
//   final String birthday; // Added field
//   final String phoneNumber; // Added field
//   final DateTime notificationTime; // New field for notification time
//   final String? id;

//   Appointment({
//     required this.id,
//     required this.date,
//     required this.charges,
//     required this.time,
//     required this.stylist,
//     required this.specialistUid,
//     required this.userUid,
//     required this.duration,
//     required this.appointmentFor,
//     this.isUpComing = false,
//     this.isWaiting = false,
//     required this.gender, // Added field
//     required this.birthday, // Added field
//     required this.phoneNumber, // Added field
//     required this.notificationTime, // New field
//   });

//   // Converts Appointment object to a Map to store in Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'date': date.toIso8601String(), // Store as ISO 8601 String
//       'time': time,
//       'specialistName': stylist,
//       'charges': charges,
//       'specialistUid': specialistUid,
//       'userUid': userUid,
//       'duration': duration,
//       'treatment': appointmentFor,
//       'isUpComing': isUpComing,
//       'isRemindMe': isRemindMe,
//       'isWaiting': isWaiting,
//       'gender': gender, // Added field
//       'birthday': birthday, // Added field
//       'phoneNumber': phoneNumber, // Added field
//       'notificationTime':
//           notificationTime.toIso8601String(), // Store as ISO 8601 String
//       'id': id,
//     };
//   }

//   // Converts a Firestore document to an Appointment object
//   factory Appointment.fromFirestore(Map<String, dynamic> data) {
//     String parseString(dynamic value) {
//       if (value == null) return '';
//       if (value is String) return value;
//       if (value is int) return value.toString(); // Convert int to String
//       throw Exception('Unexpected type for String field: $value');
//     }

//     DateTime parseDate(dynamic value) {
//       if (value is Timestamp) {
//         return value.toDate(); // Convert Firestore Timestamp to DateTime
//       } else if (value is String) {
//         return DateTime.parse(value); // Parse ISO 8601 String to DateTime
//       } else {
//         throw Exception('Unexpected type for DateTime field: $value');
//       }
//     }

//     return Appointment(
//       date: parseDate(data['date']),
//       time: parseString(data['time']),
//       charges: parseString(data['charges']),
//       stylist: parseString(data['specialistName']),
//       specialistUid: parseString(data['specialistUid']),
//       userUid: parseString(data['userUid']),
//       duration: parseString(data['duration']),
//       appointmentFor: parseString(data['treatment']),
//       id: parseString(data['id']),
//       gender: parseString(data['gender']), // Added field
//       birthday: parseString(data['birthday']), // Added field
//       phoneNumber: parseString(data['phoneNumber']), // Added field
//       notificationTime: parseDate(data['notificationTime']),
//     );
//   }
// }
