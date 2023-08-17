﻿import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/network_user.dart';

//flutterfire configure

class RealtimeDbService {
  late DatabaseReference messagesRef;
  late DatabaseReference usersRef;
  late DatabaseReference userContactsRef;
  late List myContactsIds;

  init(FirebaseApp firebaseApp) {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);
    messagesRef = database.ref('messages');
    usersRef = database.ref('users');
    userContactsRef = database.ref('userContacts');
  }

  Future sendMessage(userId, text) async {
    final message = Message(
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

  Future addOrUpdateUser(userId, name, photoURL) async {
    final user = NetworkUser(id: userId, displayName: name, photoURL: photoURL);
    await usersRef.child(userId).set(user.toJson());
  }

  Stream<List<NetworkUser>> allUsersStream() => usersRef.onValue.map((e) {
        List<NetworkUser> usersList = [];

        final firebaseUsers = Map<dynamic, dynamic>.from(
            e.snapshot.value as Map<dynamic, dynamic>);

        firebaseUsers.forEach((key, value) {
          final currentUser = Map<String, dynamic>.from(value);
          usersList.add(NetworkUser.fromJson(currentUser));
        });

        return usersList;
      });

  Stream<List<NetworkUser>> myContactsStream(String myUUID) {
    userContactsRef.child(myUUID).onValue.listen((event) {
      final myContacts = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      myContactsIds = myContacts.values.toList();
    });

    return usersRef.onValue.map((e) {
      List<NetworkUser> usersList = [];
      NetworkUser currentNetUser;

      final firebaseUsers =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);

      firebaseUsers.forEach((key, value) {
        final currentUserJson = Map<String, dynamic>.from(value);
        currentNetUser = NetworkUser.fromJson(currentUserJson);

        if (myContactsIds.contains(currentNetUser.id)) {
          usersList.add(NetworkUser.fromJson(currentUserJson));
        }
      });
      return usersList;
    });
  }

  Future addContact(userId, contactId) async {
    final contactRef = userContactsRef.child(userId).push();
    await contactRef.set(contactId);
  }
}
