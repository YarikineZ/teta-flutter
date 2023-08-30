import 'package:messenger/models/db_user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<int> saveUser(DbUser dbUser) async {
    final isar = await db;
    return isar.writeTxnSync<int>(() => isar.dbUsers.putSync(dbUser));
  }

  Future<List<DbUser>> getDbUsers() async {
    final isar = await db;
    return await isar.dbUsers.where().findAll();
  }

  Stream<List<DbUser>> listenToUsers() async* {
    final isar = await db;
    yield* isar.dbUsers.where().watch();
  }

  Future<void> cleanDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([DbUserSchema],
          inspector: true, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }
}
