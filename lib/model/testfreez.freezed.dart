// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'testfreez.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TestFreezTearOff {
  const _$TestFreezTearOff();

  _TestFreez call(
      {required String name, required int id, required bool isError}) {
    return _TestFreez(
      name: name,
      id: id,
      isError: isError,
    );
  }
}

/// @nodoc
const $TestFreez = _$TestFreezTearOff();

/// @nodoc
mixin _$TestFreez {
  String get name => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestFreezCopyWith<TestFreez> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestFreezCopyWith<$Res> {
  factory $TestFreezCopyWith(TestFreez value, $Res Function(TestFreez) then) =
      _$TestFreezCopyWithImpl<$Res>;
  $Res call({String name, int id, bool isError});
}

/// @nodoc
class _$TestFreezCopyWithImpl<$Res> implements $TestFreezCopyWith<$Res> {
  _$TestFreezCopyWithImpl(this._value, this._then);

  final TestFreez _value;
  // ignore: unused_field
  final $Res Function(TestFreez) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? id = freezed,
    Object? isError = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isError: isError == freezed
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$TestFreezCopyWith<$Res> implements $TestFreezCopyWith<$Res> {
  factory _$TestFreezCopyWith(
          _TestFreez value, $Res Function(_TestFreez) then) =
      __$TestFreezCopyWithImpl<$Res>;
  @override
  $Res call({String name, int id, bool isError});
}

/// @nodoc
class __$TestFreezCopyWithImpl<$Res> extends _$TestFreezCopyWithImpl<$Res>
    implements _$TestFreezCopyWith<$Res> {
  __$TestFreezCopyWithImpl(_TestFreez _value, $Res Function(_TestFreez) _then)
      : super(_value, (v) => _then(v as _TestFreez));

  @override
  _TestFreez get _value => super._value as _TestFreez;

  @override
  $Res call({
    Object? name = freezed,
    Object? id = freezed,
    Object? isError = freezed,
  }) {
    return _then(_TestFreez(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isError: isError == freezed
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
class _$_TestFreez extends _TestFreez {
  const _$_TestFreez(
      {required this.name, required this.id, required this.isError})
      : super._();

  @override
  final String name;
  @override
  final int id;
  @override
  final bool isError;

  @override
  String toString() {
    return 'TestFreez(name: $name, id: $id, isError: $isError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TestFreez &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.isError, isError) ||
                const DeepCollectionEquality().equals(other.isError, isError)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(isError);

  @JsonKey(ignore: true)
  @override
  _$TestFreezCopyWith<_TestFreez> get copyWith =>
      __$TestFreezCopyWithImpl<_TestFreez>(this, _$identity);
}

abstract class _TestFreez extends TestFreez {
  const factory _TestFreez(
      {required String name,
      required int id,
      required bool isError}) = _$_TestFreez;
  const _TestFreez._() : super._();

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  int get id => throw _privateConstructorUsedError;
  @override
  bool get isError => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TestFreezCopyWith<_TestFreez> get copyWith =>
      throw _privateConstructorUsedError;
}
