import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

//flutterfire configure

class DatabaseService with ChangeNotifier {
  late DatabaseReference messagesRef;

  Future init(FirebaseApp firebaseApp) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);
    messagesRef = database.ref('messages');
  }

  Future<void> _setNewName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
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
}
