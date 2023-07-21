import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb hide PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:messenger/services/database_servise.dart';
import 'package:messenger/services/storage_servise.dart';
import 'package:messenger/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'pages/home_page.dart';
import 'package:messenger/pages/map_page.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
      name: 'aaa', options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders(
    [PhoneAuthProvider()],
    app: firebaseApp,
  );

  final database = DatabaseService();
  await database.init(firebaseApp);
  final storage = StorageService();
  await storage.init(firebaseApp);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await FirebaseUIAuth.signOut(); //TODO DELL

  final getIt = GetIt.instance;
  getIt.registerSingleton<DatabaseService>(database);
  getIt.registerSingleton<StorageService>(storage);
  getIt.registerSingleton<SharedPreferences>(prefs);

  UserService userService = UserService();

  fb.FirebaseAuth.instance.authStateChanges().listen((fb.User? fbUser) {
    if (fbUser == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');

      userService.init(fbUser);
      getIt.registerSingleton<UserService>(
          userService); //возможно нужно поставить выше, там где остальные
    }
  });

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
      initialRoute:
          fb.FirebaseAuth.instance.currentUser == null ? '/phone' : '/home',
      routes: {
        '/map': (context) => const MapPage(),
        '/home': (context) => const HomePage(),
        '/phone': (context) => PhoneInputScreen(
              actions: [
                SMSCodeRequestedAction((context, action, flowKey, phoneNumber) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SMSCodeInputScreen(
                        flowKey: flowKey,
                        actions: [
                          AuthStateChangeAction<SignedIn>((context, state) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          })
                        ],
                      ),
                    ),
                  );
                }),
              ],
            )
      },
    );
  }
}
