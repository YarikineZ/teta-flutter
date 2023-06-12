import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// flutter pub run build_runner build

@freezed
class User with _$User {
  const factory User({
    required String name,
    required String uuid,
  }) = _User;

  // void set name(String newName) {
  //   name = newName;
  // }

  // void set uuid(String newuUUID) {
  //   uuid = newuUUID;
  // }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
