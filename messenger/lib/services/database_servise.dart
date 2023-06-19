import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';

//flutterfire configure

class DatabaseService with ChangeNotifier {
  late DatabaseReference messagesRef;
  late DatabaseReference usersRef;

  Future init(FirebaseApp firebaseApp) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);
    messagesRef = database.ref('messages');
    usersRef = database.ref('users');
  }

  Future sendMessage(userId, text) async {
    final message = Message(
        //userId: uuid.substring(0, 8),
        userId: userId.substring(0, 8),
        text: text,
        timestamp: DateTime.now().millisecondsSinceEpoch);

    final messageRef = messagesRef.push();
    await messageRef.set(message.toJson());
  }

  Stream<List<Message>> messagesStream() => messagesRef.onValue.map((e) {
        List<Message> messageList = [];

        final firebaseMessages = Map<dynamic, dynamic>.from(
            e.snapshot.value as Map<dynamic, dynamic>);

        firebaseMessages.forEach((key, value) {
          final currentMessage = Map<String, dynamic>.from(value);
          messageList.add(Message.fromJson(currentMessage));
        });

        messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return messageList;
      });

  Future updateUser(userId, name, photoURL) async {
    final user = User(id: userId, displayName: name, photoURL: photoURL);
    await usersRef.child(userId).set(user.toJson());
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];
    var snapshot = await usersRef.get();

    final firebaseUsers =
        Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

    firebaseUsers.forEach((key, value) {
      final currentUser = Map<String, dynamic>.from(value);
      users.add(User.fromJson(currentUser));
    });

    return users;
  }
}
// Создать модель User c полями
// id
// displayName
// photoUrl
// При изменении имени сохранять значение в Firebase /users/id/displayName
// При изменении фото сохранять значение URL в /users/id/photoUrl
// Загружать и выводить список всех /users на странице контактов