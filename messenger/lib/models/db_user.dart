import 'package:isar/isar.dart';
part 'db_user.g.dart';

// flutter pub run build_runner build

@collection
class DbUser {
  Id? id = Isar.autoIncrement;
  String? userId;
  String? displayName;
  String? photoURL;

  DbUser({userId, displayName, photoURL}); //удалить если крашннет
}
