import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/pages/chat_page.dart';
import 'package:messenger/pages/chats_list_page.dart';
import 'package:messenger/pages/contacts_page.dart';
import 'package:messenger/pages/settings_page.dart';
import 'package:messenger/services/database_servise.dart';
import 'package:messenger/services/shared_preferences_service.dart';
import 'package:messenger/services/storage_servise.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
      name: 'aaa', options: DefaultFirebaseOptions.currentPlatform);

  final sharedPreferences = SharedPreferencesService();
  await sharedPreferences.init();
  final database = DatabaseService();
  await database.init(firebaseApp);
  final storage = StorageService();
  await storage.init(firebaseApp);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => database),
        ChangeNotifierProvider(create: (context) => storage),
        ChangeNotifierProvider(create: (context) => sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const ALL(),
    );
  }
}

class ALL extends StatefulWidget {
  const ALL({super.key});

  @override
  State<ALL> createState() => _ALLState();
}

class _ALLState extends State<ALL> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ContactsPage(),
    ChatsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
