import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

// flutter pub run build_runner build

@freezed
class Message with _$Message {
  const factory Message({
    required String userId,
    required String text,
    required int timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
