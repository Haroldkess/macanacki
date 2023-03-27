import 'package:freezed_annotation/freezed_annotation.dart';

part 'testfreez.freezed.dart';

@freezed
class TestFreez with _$TestFreez {
  const TestFreez._();
  const factory TestFreez({required String name,required int id,required bool isError}) = _TestFreez;
}
