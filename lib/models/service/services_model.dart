import 'package:freezed_annotation/freezed_annotation.dart';

part 'services_model.freezed.dart';
part 'services_model.g.dart';

@freezed
class ServicesModel with _$ServicesModel {
  const factory ServicesModel({
    required String uid, // Unique identifier for the service
    required String name,
    required String imageUrl, // URL of the uploaded image
    required String duration, // "30 minutes", "45 minutes", etc.
    required String gender, // "Male", "Female", "Both"
    required double price, // Price of the ServicesModel
  }) = _ServicesModel;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => _$ServicesModelFromJson(json);
}
