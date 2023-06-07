import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../firebase_options.dart';

class DatabaseService with ChangeNotifier {
  late DatabaseReference ref;
  late String uuid;
  late DatabaseReference abRef;

  DatabaseService() {
    init();
    abRef = FirebaseDatabase.instance.ref("messages");
  }

  Future init() async {
    var firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);
    ref = database.ref();

    uuid = await _getUUID();
  }

  Future<String> _getUUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? oldUuid = prefs.getString('uuid');
    if (oldUuid != null) {
      return oldUuid;
    } else {
      String newUuid = const Uuid().v4();
      await prefs.setString("uuid", newUuid);
      return newUuid;
    }
  }

  Future sendMessage(text) async {
    FirebaseDatabase database = FirebaseDatabase.instance;

    ref = database.ref();

    final message = Message(
        userId: uuid.substring(0, 8),
        text: text,
        timestamp: DateTime.now().millisecondsSinceEpoch);

    final messageRef = ref.child("messages").push();
    await messageRef.set(message.toJson());
  }

  Stream<List<Message>> messagesStream() => abRef.onValue.map((e) {
        List<Message> messageList = [];

        final firebaseMessages = Map<dynamic, dynamic>.from(
            (e).snapshot.value as Map<dynamic, dynamic>);

        // firebaseMessages.forEach((key, value) {
        //   messageList.add(Message.fromJson(value));
        // });

        firebaseMessages.forEach((key, value) {
          messageList.add(Message(
              text: value["text"],
              userId: value["userId"],
              timestamp: value["timestamp"]));
        });
        messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return messageList;
        // тут параметр e - это сырые данные из бд. Здесь их нужно преобразовать в List<Message> и вернуть
      });
}
