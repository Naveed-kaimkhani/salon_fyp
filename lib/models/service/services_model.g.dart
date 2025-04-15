// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicesModelImpl _$$ServicesModelImplFromJson(Map<String, dynamic> json) =>
    _$ServicesModelImpl(
      uid: json['uid'] as String,
      salon_id: json['salon_id'] as String,
      name: json['name'] as String,
      bussinessName: json['bussinessName'] as String,
      imageUrl: json['imageUrl'] as String,
      duration: json['duration'] as String,
      gender: json['gender'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ServicesModelImplToJson(_$ServicesModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'salon_id': instance.salon_id,
      'name': instance.name,
      'bussinessName': instance.bussinessName,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'gender': instance.gender,
      'price': instance.price,
    };
