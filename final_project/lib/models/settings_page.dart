import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_page.freezed.dart';

@freezed
class SettingsPageModel with _$SettingsPageModel {
  const factory SettingsPageModel({
    required String userName,
    required String avatarURL,
    required bool isEdit,
    required bool isSnackBar,
  }) = _SettingsPageModel;
}
