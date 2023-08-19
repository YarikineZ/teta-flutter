import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/network_user.dart';

//flutterfire configure

class RealtimeDbService {
  late DatabaseReference messagesRef;
  late DatabaseReference chatsRef;
  late DatabaseReference usersRef;
  late DatabaseReference userContactsRef;
  late DatabaseReference userChatsRef;
  late List myContactsIds;
  late List myChatIds;

  init(FirebaseApp firebaseApp) {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);
    messagesRef = database.ref('messages');
    chatsRef = database.ref('chats');
    usersRef = database.ref('users');
    userContactsRef = database.ref('userContacts');
    userChatsRef = database.ref('userChats');
  }

  Future sendMessage(userId, chatId, text) async {
    //TODO чет ничего не понятно. Надо доделать
    var nowTime = DateTime.now().millisecondsSinceEpoch;

    final message = Message(userId: userId, text: text, timestamp: nowTime);
    final messageRef = messagesRef.child(chatId).push();
    await messageRef.set(message.toJson());
  }

  Future updateChat(chatId, lastmessage, timestamp, {title = "TMP"}) async {
    //Только для отображения на экране "Чаты"
    // добавить поиск имени по chatID
    final chat = Chat(
        id: chatId,
        title: "TMP",
        lastmessage: lastmessage,
        timestamp: timestamp);
    final chatRef = chatsRef.push();
    await chatRef.set(chat.toJson());
  }

  Future<String> startNewChat(myId, contactId) async {
    //Создаем новый чат
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    final chatRef = chatsRef.push();
    final chat = Chat(
        id: chatRef.key!,
        title: "TMP",
        lastmessage: "BRAND NEW CHAT CREATED",
        timestamp: nowTime);
    await chatRef.set(chat.toJson());

    //Добавляем его 2м пользователям
    //TODO Добавить проверку на наличие готового чата
    await userChatsRef.child(myId).push().set(chatRef.key);
    await userChatsRef.child(contactId).push().set(chatRef.key);

    return chatRef.key!;
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

  //тестовый метод не для релиза
  Stream<List<Message>> allMessagesStream(String chatId) =>
      messagesRef.child(chatId).onValue.map((e) {
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

  //Более не используется
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

  Stream<List<Chat>> myChatsStream(String myUUID) {
    userChatsRef.child(myUUID).onValue.listen((event) {
      final myChats = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      myChatIds = myChats.values.toList();
    });

    return chatsRef.onValue.map((e) {
      List<Chat> chatsList = [];
      Chat current;

      final firebaseChats =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);

      firebaseChats.forEach((key, value) {
        final currentChatJson = Map<String, dynamic>.from(value);
        current = Chat.fromJson(currentChatJson);

        if (myChatIds.contains(current.id)) {
          chatsList.add(Chat.fromJson(currentChatJson));
        }
      });

      return chatsList;
    });
  }
}
