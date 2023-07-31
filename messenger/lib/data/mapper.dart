import 'package:messenger/models/db_user.dart';
import 'package:messenger/models/network_user.dart';
import '../models/user.dart';

class Mapper {
  User toUserFromNetworkUser(NetworkUser networkUser) => User(
      id: networkUser.id,
      displayName: networkUser.displayName,
      photoURL: networkUser.photoURL);

  Stream<List<User>> toUsersStreamfromNetworkUsersStream(
          Stream<List<NetworkUser>> st) =>
      st.map((event) => event.map((e) => toUserFromNetworkUser(e)).toList());

  DbUser toDbUserFromNetworkUser(NetworkUser networkUser) => DbUser(
      userId: networkUser.id,
      displayName: networkUser.displayName,
      photoURL: networkUser.photoURL);
}
