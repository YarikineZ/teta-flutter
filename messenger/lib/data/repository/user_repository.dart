import 'package:messenger/services/firebase_servise.dart';

import '../../models/user.dart';

class UserRepository {
  final DatabaseService databaseService;

  UserRepository({required this.databaseService});

  Future<List<User>> getUser() async {
    return [const User(displayName: "name", id: "1", photoURL: "url")];
  }
}
