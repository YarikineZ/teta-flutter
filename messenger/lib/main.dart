import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/services/database_servise.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Чтобы Flutter успел инициализировать fluter channel перед Firebase

  var firebaseApp = await Firebase.initializeApp(
      name: "flutter-messenger", //Название проекта в Firebase
      options: DefaultFirebaseOptions.currentPlatform);

  final databaseService = DatabaseService();
  databaseService.getData(firebaseApp);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        bottomSheet: Padding(
          //padding: MediaQuery.of(context).viewInsets,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.never),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send))
            ],
          ),
        ));
    return scaffold;
  }
}
