import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'package:messenger/services/user_service.dart';

import '../models/settings_page.dart';
import '../services/storage_servise.dart';

class SettingsScreenController extends StateNotifier<SettingsPageModel> {
  final TextEditingController textEditingController = TextEditingController();
  final UserService userService = GetIt.I.get<UserService>();
  final StorageService storage = GetIt.I.get<StorageService>();

  // SettingsScreenController(super.state); // требует начальных параметров при инициализацити

  SettingsScreenController()
      : super(
          const SettingsPageModel(
              userName: "No user name",
              avatarURL:
                  "https://cdn-icons-png.flaticon.com/512/2202/2202112.png",
              isEdit: false,
              isSnackBar: false), //TODO убрать?
        );

  void edit() {
    state = state.copyWith(isEdit: true);
    textEditingController.text = userService.user.displayName;
  }

  void done() {
    state = state.copyWith(userName: textEditingController.text, isEdit: false);
    userService.setName(textEditingController.text);
  }

  void updateUserName(String newName) {
    state = state.copyWith(userName: newName);
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String downloadURL = await storage.pushImage(image.name, image.path);
      userService.setAvatar(downloadURL);
      state = state.copyWith(avatarURL: downloadURL);
    }
  }

  void copyUUID() async {
    await Clipboard.setData(ClipboardData(text: userService.user.id));
    state = state.copyWith(isSnackBar: true);
    Future.delayed(const Duration(seconds: 3), () {
      state = state.copyWith(isSnackBar: false);
    });
  }
}
