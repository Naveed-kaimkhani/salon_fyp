// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffModel _$StaffModelFromJson(Map<String, dynamic> json) {
  return _StaffModel.fromJson(json);
}

/// @nodoc
mixin _$StaffModel {
  String get uid =>
      throw _privateConstructorUsedError; // Unique ID for each user
  String get role => throw _privateConstructorUsedError; // User's email address
  String get displayName =>
      throw _privateConstructorUsedError; // User's display name
  String get startTime =>
      throw _privateConstructorUsedError; // User's phone number
  String get endTime =>
      throw _privateConstructorUsedError; // User's phone number
  String get photoURL =>
      throw _privateConstructorUsedError; // URL to the user's profile picture
  List<String> get days => throw _privateConstructorUsedError;
  List<String> get listOfServices => throw _privateConstructorUsedError;

  /// Serializes this StaffModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffModelCopyWith<StaffModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffModelCopyWith<$Res> {
  factory $StaffModelCopyWith(
          StaffModel value, $Res Function(StaffModel) then) =
      _$StaffModelCopyWithImpl<$Res, StaffModel>;
  @useResult
  $Res call(
      {String uid,
      String role,
      String displayName,
      String startTime,
      String endTime,
      String photoURL,
      List<String> days,
      List<String> listOfServices});
}

/// @nodoc
class _$StaffModelCopyWithImpl<$Res, $Val extends StaffModel>
    implements $StaffModelCopyWith<$Res> {
  _$StaffModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? role = null,
    Object? displayName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? photoURL = null,
    Object? days = null,
    Object? listOfServices = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<String>,
      listOfServices: null == listOfServices
          ? _value.listOfServices
          : listOfServices // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffModelImplCopyWith<$Res>
    implements $StaffModelCopyWith<$Res> {
  factory _$$StaffModelImplCopyWith(
          _$StaffModelImpl value, $Res Function(_$StaffModelImpl) then) =
      __$$StaffModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String role,
      String displayName,
      String startTime,
      String endTime,
      String photoURL,
      List<String> days,
      List<String> listOfServices});
}

/// @nodoc
class __$$StaffModelImplCopyWithImpl<$Res>
    extends _$StaffModelCopyWithImpl<$Res, _$StaffModelImpl>
    implements _$$StaffModelImplCopyWith<$Res> {
  __$$StaffModelImplCopyWithImpl(
      _$StaffModelImpl _value, $Res Function(_$StaffModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? role = null,
    Object? displayName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? photoURL = null,
    Object? days = null,
    Object? listOfServices = null,
  }) {
    return _then(_$StaffModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<String>,
      listOfServices: null == listOfServices
          ? _value._listOfServices
          : listOfServices // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffModelImpl implements _StaffModel {
  _$StaffModelImpl(
      {this.uid = '',
      this.role = '',
      this.displayName = '',
      this.startTime = '',
      this.endTime = '',
      this.photoURL = '',
      final List<String> days = const [],
      final List<String> listOfServices = const []})
      : _days = days,
        _listOfServices = listOfServices;

  factory _$StaffModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffModelImplFromJson(json);

  @override
  @JsonKey()
  final String uid;
// Unique ID for each user
  @override
  @JsonKey()
  final String role;
// User's email address
  @override
  @JsonKey()
  final String displayName;
// User's display name
  @override
  @JsonKey()
  final String startTime;
// User's phone number
  @override
  @JsonKey()
  final String endTime;
// User's phone number
  @override
  @JsonKey()
  final String photoURL;
// URL to the user's profile picture
  final List<String> _days;
// URL to the user's profile picture
  @override
  @JsonKey()
  List<String> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  final List<String> _listOfServices;
  @override
  @JsonKey()
  List<String> get listOfServices {
    if (_listOfServices is EqualUnmodifiableListView) return _listOfServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listOfServices);
  }

  @override
  String toString() {
    return 'StaffModel(uid: $uid, role: $role, displayName: $displayName, startTime: $startTime, endTime: $endTime, photoURL: $photoURL, days: $days, listOfServices: $listOfServices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            const DeepCollectionEquality()
                .equals(other._listOfServices, _listOfServices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      role,
      displayName,
      startTime,
      endTime,
      photoURL,
      const DeepCollectionEquality().hash(_days),
      const DeepCollectionEquality().hash(_listOfServices));

  /// Create a copy of StaffModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffModelImplCopyWith<_$StaffModelImpl> get copyWith =>
      __$$StaffModelImplCopyWithImpl<_$StaffModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffModelImplToJson(
      this,
    );
  }
}

abstract class _StaffModel implements StaffModel {
  factory _StaffModel(
      {final String uid,
      final String role,
      final String displayName,
      final String startTime,
      final String endTime,
      final String photoURL,
      final List<String> days,
      final List<String> listOfServices}) = _$StaffModelImpl;

  factory _StaffModel.fromJson(Map<String, dynamic> json) =
      _$StaffModelImpl.fromJson;

  @override
  String get uid; // Unique ID for each user
  @override
  String get role; // User's email address
  @override
  String get displayName; // User's display name
  @override
  String get startTime; // User's phone number
  @override
  String get endTime; // User's phone number
  @override
  String get photoURL; // URL to the user's profile picture
  @override
  List<String> get days;
  @override
  List<String> get listOfServices;

  /// Create a copy of StaffModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffModelImplCopyWith<_$StaffModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
