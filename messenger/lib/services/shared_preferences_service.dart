import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class SharedPreferencesService with ChangeNotifier {
  SharedPreferencesService(this.firebaseApp);
  //late User user;
  late String uuid;
  late String name;
  late String avatarURL;
  late final SharedPreferences prefs;

  final FirebaseApp firebaseApp;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    _clearSharedProferencesData(); //{}- ничего...
  }

  Future loadUser() async {
    uuid = await _getUUID();
    name = await _getName();
    avatarURL = await _getAvatarURL();
  }

  Future<void> saveNewName(String newName) async {
    name = newName;
    await prefs.setString("name", name);
  }

  Future<String> _getName() async {
    final String? name = prefs.getString('name');
    if (name != null) {
      return name;
    } else {
      print("USER NAME IS NULL");
      return "No user name";
    }
  }

  Future<String> _getUUID() async {
    final String? oldUuid = prefs.getString('uuid');
    if (oldUuid != null) {
      return oldUuid;
    } else {
      String newUuid =
          FirebaseAuth.instanceFor(app: firebaseApp).currentUser!.uid;
      await prefs.setString("uuid", newUuid);
      return newUuid;
    }
  }

  Future<String> _getAvatarURL() async {
    String defaultAvatarURL =
        "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";
    final String? oldURL = prefs.getString('avatarURL');
    if (oldURL != null) {
      return oldURL;
    } else {
      await prefs.setString("avatarURL", defaultAvatarURL);
      return defaultAvatarURL;
    }
  }

  void setAvatarURL(String newURL) async {
    await prefs.setString("avatarURL", newURL);
  }

  void _clearSharedProferencesData() {
    var keys = prefs.getKeys();
    print(keys);
  }
}
