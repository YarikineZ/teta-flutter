import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/services/isar_servise.dart';
import 'package:messenger/services/realtime_db_servise.dart';

import '../../models/network_user.dart';
import '../../models/user.dart';
import '../mapper.dart';

class UserRepository {
  FirebaseApp firebaseApp;
  final RealtimeDbService firebaseDbService = RealtimeDbService();
  final IsarService isarService = IsarService();
  final mapper = Mapper();

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
    // возвращает стрим пользоавтелей ннна экран Contacts
    // имеет внутреннюю логику - выбирает откуда брать стрим: из базы или из сети

    // пока берет из сети и сохраняет в базу
    var stream = firebaseDbService.usersStream();
    final usersStream = mapper.toUsersStreamfromNetworkUsers(stream);

    return usersStream;
  }

  // void saveUsers(Stream<List<NetworkUser>> usersStream) {
  //   print("=========");
  //   print("saveUsers FUNC");
  //   print(usersStream);
  //   print("=========");
  //   usersStream.map((event) => print(event));
  //   usersStream.map((event) => event.map((e) => print(e)));
  //   usersStream.map((event) => event.map((e) async =>
  //       print(await isar.saveUser(mapper.toDbUserFromNetworkUser(e)))));
  // }
}
