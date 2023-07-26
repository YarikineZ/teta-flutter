import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

part 'network_user.freezed.dart';
part 'network_user.g.dart';

// flutter pub run build_runner build

@freezed
class NetworkUser with _$NetworkUser {
  const factory NetworkUser({
    required String id,
    required String displayName,
    required String photoURL,
  }) = _NetworkUser;

  factory NetworkUser.fromJson(Map<String, dynamic> json) =>
      _$NetworkUserFromJson(json);
}
