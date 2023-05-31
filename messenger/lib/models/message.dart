import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message(
      {required String userId,
      required final String text,
      required final int timestamp}) = _Message;

  factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);

  // Message.fromMap(Map<String, dynamic> data)
  //     : userId = data["userId"],
  //       text = data['text'],
  //       timestamp = data['timestamp'];
}
