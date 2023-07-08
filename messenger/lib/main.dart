import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:messenger/services/database_servise.dart';
import 'package:messenger/services/shared_preferences_service.dart';
import 'package:messenger/services/storage_servise.dart';

import 'firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'pages/home_page.dart';

GetIt getIt = GetIt.instance;

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

  final getIt = GetIt.instance;

  getIt.registerSingleton<SharedPreferencesService>(sharedPreferences);
  getIt.registerSingleton<DatabaseService>(database);
  getIt.registerSingleton<StorageService>(storage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        fontFamily: 'TimesNewRoman',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
