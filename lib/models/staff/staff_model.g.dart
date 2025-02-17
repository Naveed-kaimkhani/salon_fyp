// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffModelImpl _$$StaffModelImplFromJson(Map<String, dynamic> json) =>
    _$StaffModelImpl(
      uid: json['uid'] as String? ?? '',
      role: json['role'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      days:
          (json['days'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      listOfServices: (json['listOfServices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$StaffModelImplToJson(_$StaffModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'role': instance.role,
      'displayName': instance.displayName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'photoURL': instance.photoURL,
      'days': instance.days,
      'listOfServices': instance.listOfServices,
    };
