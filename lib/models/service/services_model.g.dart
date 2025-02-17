// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicesModelImpl _$$ServicesModelImplFromJson(Map<String, dynamic> json) =>
    _$ServicesModelImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      duration: json['duration'] as String,
      gender: json['gender'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ServicesModelImplToJson(_$ServicesModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'gender': instance.gender,
      'price': instance.price,
    };
