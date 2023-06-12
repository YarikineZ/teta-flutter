import 'package:flutter/cupertino.dart';
//import 'package:messenger/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StorageService with ChangeNotifier {
  //late User user;
  late String uuid;
  late String name;
  late final SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    // user.uuid = await _getUUID();
    // user.name = await _getName();
    uuid = await _getUUID();
    name = await _getName();
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
      String newUuid = const Uuid().v4();
      await prefs.setString("uuid", newUuid);
      return newUuid;
    }
  }
}
