import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/services/database_servise.dart';
import 'firebase_options.dart';
import 'models/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';

void main() async {
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _database = DatabaseService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _database.init();

    var scaffold = Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
        ),
        body: StreamBuilder(
            stream: _database.abRef.onValue,
            builder: (context, snapshot) {
              List<Message> messageList = [];

              if (snapshot.hasData &&
                  snapshot.data != null &&
                  (snapshot.data!).snapshot.value != null) {
                final firebaseMessages = Map<dynamic, dynamic>.from(
                    (snapshot.data!).snapshot.value as Map<dynamic, dynamic>);
                firebaseMessages.forEach((key, value) {
                  final currentMessage = Map<String, dynamic>.from(value);
                  messageList.add(Message.fromMap(currentMessage));
                });
                messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                        reverse: false,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(messageList[index].userId,
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
            }),
        bottomSheet: Padding(
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
                    _database.sendMessage(_controller.text);
                    _controller.text = "";
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        ));
    return scaffold;
  }
}
