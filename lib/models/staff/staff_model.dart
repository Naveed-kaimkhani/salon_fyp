import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@freezed
class StaffModel with _$StaffModel {

  factory StaffModel({
    @Default('') String uid,            // Unique ID for each user
    @Default('') String displayName,    // User's display name
    @Default('') String role,          // User's email address
    @Default('') String startTime,    // User's phone number
    @Default('') String endTime,    // User's phone number
    @Default('') String photoURL,       // URL to the user's profile picture
    @Default([]) List<String> days,
    @Default([]) List<String> listOfServices,          // Authentication token if needed
    @Default('') String salonId,        // ID of the salon this staff belongs to
  }) = _StaffModel;

  factory StaffModel.fromJson(Map<String, dynamic> json) => _$StaffModelFromJson(json);
}
