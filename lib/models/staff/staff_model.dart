// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'staff_model.freezed.dart';
// part 'staff_model.g.dart';

// @freezed
// class StaffModel with _$StaffModel {

//   factory StaffModel({
//     @Default('') String uid,            // Unique ID for each user
//     @Default('') String role,          // User's email address
//     @Default('') String displayName,    // User's display name
//     @Default('') String startTime,    // User's phone number
//     @Default('') String endTime,    // User's phone number
//     @Default('') String photoURL,       // URL to the user's profile picture
//     @Default([]) List<String> days,
//     @Default([]) List<String> listOfServices,          // Authentication token if needed
//     @Default('') String salonId,        // ID of the salon this staff belongs to

//   }) = _StaffModel;

//   factory StaffModel.fromJson(Map<String, dynamic> json) => _$StaffModelFromJson(json);
// }



class StaffModel {
  final String uid;
  final String role;
  final String displayName;
  final String startTime;
  final String endTime;
  final String photoURL;
  final List<String> days;
  final List<String> listOfServices;
  final String salonId;

  StaffModel({
    this.uid = '',
    this.role = '',
    this.displayName = '',
    this.startTime = '',
    this.endTime = '',
    this.photoURL = '',
    this.days = const [],
    this.listOfServices = const [],
    this.salonId = '',
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      uid: json['uid'] ?? '',
      role: json['role'] ?? '',
      displayName: json['displayName'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      photoURL: json['photoURL'] ?? '',
      days: List<String>.from(json['days'] ?? []),
      listOfServices: List<String>.from(json['listOfServices'] ?? []),
      salonId: json['salonId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'displayName': displayName,
      'startTime': startTime,
      'endTime': endTime,
      'photoURL': photoURL,
      'days': days,
      'listOfServices': listOfServices,
      'salonId': salonId,
    };
  }
    StaffModel copyWith({
    String? uid,
    String? role,
    String? displayName,
    String? startTime,
    String? endTime,
    String? photoURL,
    List<String>? days,
    List<String>? listOfServices,
    String? salonId,
  }) {
    return StaffModel(
      uid: uid ?? this.uid,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      photoURL: photoURL ?? this.photoURL,
      days: days ?? this.days,
      listOfServices: listOfServices ?? this.listOfServices,
      salonId: salonId ?? this.salonId,
    );
  }

}

