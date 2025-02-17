// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'services_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServicesModel _$ServicesModelFromJson(Map<String, dynamic> json) {
  return _ServicesModel.fromJson(json);
}

/// @nodoc
mixin _$ServicesModel {
  String get uid =>
      throw _privateConstructorUsedError; // Unique identifier for the service
  String get name => throw _privateConstructorUsedError;
  String get imageUrl =>
      throw _privateConstructorUsedError; // URL of the uploaded image
  String get duration =>
      throw _privateConstructorUsedError; // "30 minutes", "45 minutes", etc.
  String get gender =>
      throw _privateConstructorUsedError; // "Male", "Female", "Both"
  double get price => throw _privateConstructorUsedError;

  /// Serializes this ServicesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServicesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServicesModelCopyWith<ServicesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServicesModelCopyWith<$Res> {
  factory $ServicesModelCopyWith(
          ServicesModel value, $Res Function(ServicesModel) then) =
      _$ServicesModelCopyWithImpl<$Res, ServicesModel>;
  @useResult
  $Res call(
      {String uid,
      String name,
      String imageUrl,
      String duration,
      String gender,
      double price});
}

/// @nodoc
class _$ServicesModelCopyWithImpl<$Res, $Val extends ServicesModel>
    implements $ServicesModelCopyWith<$Res> {
  _$ServicesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServicesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? duration = null,
    Object? gender = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServicesModelImplCopyWith<$Res>
    implements $ServicesModelCopyWith<$Res> {
  factory _$$ServicesModelImplCopyWith(
          _$ServicesModelImpl value, $Res Function(_$ServicesModelImpl) then) =
      __$$ServicesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String imageUrl,
      String duration,
      String gender,
      double price});
}

/// @nodoc
class __$$ServicesModelImplCopyWithImpl<$Res>
    extends _$ServicesModelCopyWithImpl<$Res, _$ServicesModelImpl>
    implements _$$ServicesModelImplCopyWith<$Res> {
  __$$ServicesModelImplCopyWithImpl(
      _$ServicesModelImpl _value, $Res Function(_$ServicesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServicesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? duration = null,
    Object? gender = null,
    Object? price = null,
  }) {
    return _then(_$ServicesModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServicesModelImpl implements _ServicesModel {
  const _$ServicesModelImpl(
      {required this.uid,
      required this.name,
      required this.imageUrl,
      required this.duration,
      required this.gender,
      required this.price});

  factory _$ServicesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServicesModelImplFromJson(json);

  @override
  final String uid;
// Unique identifier for the service
  @override
  final String name;
  @override
  final String imageUrl;
// URL of the uploaded image
  @override
  final String duration;
// "30 minutes", "45 minutes", etc.
  @override
  final String gender;
// "Male", "Female", "Both"
  @override
  final double price;

  @override
  String toString() {
    return 'ServicesModel(uid: $uid, name: $name, imageUrl: $imageUrl, duration: $duration, gender: $gender, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServicesModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, imageUrl, duration, gender, price);

  /// Create a copy of ServicesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServicesModelImplCopyWith<_$ServicesModelImpl> get copyWith =>
      __$$ServicesModelImplCopyWithImpl<_$ServicesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServicesModelImplToJson(
      this,
    );
  }
}

abstract class _ServicesModel implements ServicesModel {
  const factory _ServicesModel(
      {required final String uid,
      required final String name,
      required final String imageUrl,
      required final String duration,
      required final String gender,
      required final double price}) = _$ServicesModelImpl;

  factory _ServicesModel.fromJson(Map<String, dynamic> json) =
      _$ServicesModelImpl.fromJson;

  @override
  String get uid; // Unique identifier for the service
  @override
  String get name;
  @override
  String get imageUrl; // URL of the uploaded image
  @override
  String get duration; // "30 minutes", "45 minutes", etc.
  @override
  String get gender; // "Male", "Female", "Both"
  @override
  double get price;

  /// Create a copy of ServicesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServicesModelImplCopyWith<_$ServicesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
