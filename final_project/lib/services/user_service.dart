import 'package:get_it/get_it.dart';
import 'package:messenger/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'realtime_db_servise.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb hide PhoneAuthProvider;

class UserService {
  final RealtimeDbService database = GetIt.I.get<RealtimeDbService>();
  late fb.User fbUser;

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

    //TODO перевести проверку на realtime db
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
    // await fbUser.updateDisplayName(user.displayName);
    // await fbUser.updatePhotoURL(user.photoURL);

    database.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }

  Future<void> setName(String newName) async {
    user = user.copyWith.call(displayName: newName);
    database.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }

  Future<void> setAvatar(String newAvatarURL) async {
    user = user.copyWith.call(photoURL: newAvatarURL);
    database.addOrUpdateUser(user.id, user.displayName, user.photoURL);
  }
}
