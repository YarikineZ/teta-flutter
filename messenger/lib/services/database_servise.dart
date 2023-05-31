import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../firebase_options.dart';

class DatabaseService {
  late DatabaseReference ref;
  late Future<String> uuid;
  late DatabaseReference abRef;

  DatabaseService() {
    init();
    uuid = _getUUID();
    abRef = FirebaseDatabase.instance.ref("messages");
  }

  Future init() async {
    var firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);

    ref = database.ref();
  }

  Future<String> _getUUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? oldUuid = prefs.getString('uuid');
    if (oldUuid != null) {
      return oldUuid;
    } else {
      String newUuid = const Uuid().v4();
      prefs.setString("uuid", newUuid);
      return newUuid;
    }
  }

  Future sendMessage(text) async {
    FirebaseDatabase database = FirebaseDatabase.instance;

    ref = database.ref();

    final message = Message(
        userId: uuid.toString().substring(0, 8),
        text: text,
        timestamp: DateTime.now().millisecondsSinceEpoch);

    final messageRef = ref.child("messages").push();
    await messageRef.set(message.toJson());
  }
}
