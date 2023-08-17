import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'package:messenger/services/isar_servise.dart';
import 'package:messenger/services/realtime_db_servise.dart';

import '../../models/db_user.dart';
import '../../models/network_user.dart';
import '../../models/user.dart';
import '../mapper.dart';

class UserRepository {
  FirebaseApp firebaseApp;
  final firebaseDbService = RealtimeDbService();
  final isarService = IsarService();
  final mapper = Mapper();

  UserRepository({required this.firebaseApp});

  Future<void> init() async {
    firebaseDbService.init(firebaseApp);

    GetIt.instance.registerSingleton<RealtimeDbService>(firebaseDbService);
  }

  Stream<List<User>> usersStream() {
    var stream = firebaseDbService.allUsersStream().asBroadcastStream();
    // syncIsar(stream);

    return mapper.toUsersStreamfromNetworkUsersStream(stream);
  }

  Future<void> syncIsar(Stream<List<NetworkUser>> usersStream) async {
    // сравним стримы из isar & FB
    // если не совпадают, то затрем базу и сохраним

    await usersStream.forEach((element) {
      for (NetworkUser el in element) {
        final DbUser dbUser = mapper.toDbUserFromNetworkUser(el);
        isarService.saveUser(dbUser);
      }
    });
  }
}
