import 'package:messenger/models/network_user.dart';
import '../models/user.dart';

class Mapper {
  User toUserFromNetworkUser(NetworkUser networkUser) => User(
      id: networkUser.id,
      displayName: networkUser.displayName,
      photoURL: networkUser.photoURL);
}
