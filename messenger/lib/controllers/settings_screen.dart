import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'package:messenger/services/user_service.dart';

import '../services/storage_servise.dart';

class SettingsScreenController {
  String? name;
  String? avatarURL;
  bool isEdit = false;
  final TextEditingController textEditingController = TextEditingController();
  final UserService userService = GetIt.I.get<UserService>();
  final StorageService storage = GetIt.I.get<StorageService>();

  void edit() {
    isEdit = true;
    textEditingController.text = userService.user.displayName ?? "";
  }

  void done() {
    isEdit = false;
    userService.setName(textEditingController.text);
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String downloadURL = await storage.pushImage(image.name, image.path);
      userService.setAvatar(downloadURL);
    }
  }
}
