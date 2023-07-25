﻿import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:messenger/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'database_servise.dart';

class UserService {
  final DatabaseService database = GetIt.I.get<DatabaseService>();
  final SharedPreferences prefs = GetIt.I.get<SharedPreferences>();
  late fb.User fbUser;

  late User user;
  final defaultAvatarURL =
      "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";

  void init(fb.User _user) async {
    fbUser = _user;
    late String displayName;
    late String photoURL;

    if (fbUser.displayName != null && fbUser.displayName!.isNotEmpty) {
      displayName = fbUser.displayName!;
    } else {
      displayName = "no user name";
    }

    if (fbUser.photoURL != null && fbUser.photoURL!.isNotEmpty) {
      photoURL = fbUser.photoURL!;
    } else {
      photoURL = defaultAvatarURL;
    }
    user = User(id: fbUser.uid, displayName: displayName, photoURL: photoURL);
    saveUser();
  }

  saveUser() async {
    //так тут нужен  await или нет?
    await fbUser.updateDisplayName(user.displayName);
    await fbUser.updatePhotoURL(user.photoURL);

    await prefs.setString("uuid", user.id);
    await prefs.setString("displayName", user.displayName);
    await prefs.setString("photoURL", user.photoURL);
    database.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }

  Future<void> setName(String newName) async {
    user = user.copyWith.call(displayName: newName);
    await prefs.setString("name", newName);
    database.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }

  Future<void> setAvatar(String newAvatarURL) async {
    user = user.copyWith.call(photoURL: newAvatarURL);
    await prefs.setString("photoURL", newAvatarURL);
    database.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }
}