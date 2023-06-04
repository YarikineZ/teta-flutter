import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/services/database_servise.dart';
import 'firebase_options.dart';
import 'models/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final _database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
        ),
        body: MessagesList(database: _database),
        bottomSheet: BottomSheet(database: _database));
    return scaffold;
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required DatabaseService database,
  }) : _database = database;

  final DatabaseService _database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _database.messagesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<Message>? messageList = snapshot.data;

            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                    reverse: false,
                    itemCount: messageList?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(messageList![index].userId,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(StringToHex.toColor(
                                            messageList[index].userId)))),
                                const SizedBox(width: 6),
                                Text(
                                  timeago.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          messageList[index].timestamp)),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black38,
                                      fontSize: 13.0),
                                )
                              ]),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(messageList[index].text,
                                  style: const TextStyle(fontSize: 16.0))
                            ]),
                      );
                    }));
          } else {
            return const Center(child: Text("No messages"));
          }
        });
  }
}

class BottomSheet extends StatefulWidget {
  BottomSheet({
    super.key,
    required DatabaseService database,
  }) : _database = database;

  final DatabaseService _database;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 16.0),
              decoration: const InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ),
          IconButton(
              onPressed: () {
                widget._database.sendMessage(_controller.text);
                _controller.text = "";
              },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
