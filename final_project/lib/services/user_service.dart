import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:messenger/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'realtime_db_servise.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb hide PhoneAuthProvider;

class UserService {
  final RealtimeDbService realtimeDbService = GetIt.I.get<RealtimeDbService>();
  late fb.User fbUser;
  final StreamController<bool> _controller = StreamController<bool>();
  late Stream<bool> isInited;

  late User user;
  final defaultAvatarURL =
      "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";

  UserService() {
    fb.FirebaseAuth.instance.authStateChanges().listen((fb.User? fbUser) {
      if (fbUser == null) {
        print('User is currently signed out!');
        //TODO надо как-то сделать полную очистку приложения
      } else {
        print('User is signed in!');
        init(fbUser);
      }
    });
  }

  void init(fb.User fbuser) async {
    fbUser = fbuser;
    late String displayName;
    late String photoURL;

    //Инициализируем пользователя после авторизации, еще не знаем
    // DisplayName & photoURL. Ставим фиктивные
    user = User(id: fbUser.uid, displayName: '0.001 sec', photoURL: "tmp");

    User netUser = await realtimeDbService.getUserByUUID(fbUser.uid);

    if (netUser.displayName.isNotEmpty) {
      displayName = netUser.displayName;
    } else {
      displayName = "no user name in db";
    }

    if (netUser.photoURL.isNotEmpty) {
      photoURL = netUser.photoURL;
    } else {
      photoURL = defaultAvatarURL;
    }
    user = User(id: fbUser.uid, displayName: displayName, photoURL: photoURL);
    saveUser();
    isInited = _controller.stream.asBroadcastStream();
    _controller.sink.add(true);
  }

  saveUser() async {
    realtimeDbService.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }

  Future<void> setName(String newName) async {
    user = user.copyWith.call(displayName: newName);
    realtimeDbService.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }

  Future<void> setAvatar(String newAvatarURL) async {
    user = user.copyWith.call(photoURL: newAvatarURL);
    realtimeDbService.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }
}
