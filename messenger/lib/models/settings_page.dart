import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_page.freezed.dart';
part 'settings_page.g.dart';

@freezed
class SettingsPageModel with _$SettingsPageModel {
  const factory SettingsPageModel({
    required String userName,
    required String avatarURL,
    required bool isEdit,
  }) = _SettingsPageModel;

  factory SettingsPageModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsPageModelFromJson(json);
}
