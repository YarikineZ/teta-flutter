import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

// flutter pub run build_runner build

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String title,
    required String lastmessage,
    required int timestamp,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
