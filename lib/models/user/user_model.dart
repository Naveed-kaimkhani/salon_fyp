import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {

  factory UserModel({
    @Default('') String uid,            // Unique ID for each user
    @Default('') String email,          // User's email address
    @Default('') String displayName,    // User's display name
    @Default('') String phoneNumber,    // User's phone number
    @Default('') String photoURL,       // URL to the user's profile picture
    @Default('') String token,          // Authentication token if needed
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
