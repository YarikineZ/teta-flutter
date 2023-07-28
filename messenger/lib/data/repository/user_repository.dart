import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/services/isar_servise.dart';
import 'package:messenger/services/realtime_db_servise.dart';

import '../../models/user.dart';

class UserRepository {
  FirebaseApp firebaseApp;
  final RealtimeDbService firebaseDbService = RealtimeDbService();
  final IsarService isarService = IsarService();

  late IsarService isar;

  UserRepository({required this.firebaseApp});

  Future<void> init() async {
    firebaseDbService.init(firebaseApp);

    GetIt.instance.registerSingleton<RealtimeDbService>(firebaseDbService);
  }

  Future<List<User>> getUser() async {
    // у нас тут вообще то стрим...
    // я хочу переделать получение списка пользователкй через эту штуку

    // Получаем через коннективити статус сети
    //бращаемся к локальной баще
    // Если пусто, идем в Firebase
    // Послке получения списка сохраняем в базу

    return [];
  }

  Stream<List<User>> usersStream() {
    var stream = firebaseDbService.usersStream();
    return stream;
  }
}
