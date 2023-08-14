import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb hide PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:messenger/controllers/settings_screen_controller.dart';
import 'package:messenger/data/repository/user_repository.dart';
import 'package:messenger/models/settings_page.dart';

import 'package:messenger/services/storage_servise.dart';
import 'package:messenger/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'pages/home_page.dart';
import 'package:messenger/pages/map_page.dart';

Future<void> _onMessageOpenedApp(RemoteMessage message) async {
  print('===========');
  print('App opened from message ${message.messageId}');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('===========');
  print('Handling a background message ${message.messageId}');
}

final settingsScreeenProvider =
    StateNotifierProvider<SettingsScreenController, SettingsPageModel>((ref) {
  final controller = SettingsScreenController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
      name: 'aaa', options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings =
      await messaging.requestPermission(alert: true, badge: true, sound: true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

  FirebaseUIAuth.configureProviders(
    [PhoneAuthProvider()],
    app: firebaseApp,
  );

  final repository = UserRepository(firebaseApp: firebaseApp);
  await repository.init();

  final storage = StorageService();
  await storage.init(firebaseApp);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // await FirebaseUIAuth.signOut(); //TODO DELL

  final getIt = GetIt.instance;
  getIt.registerSingleton<UserRepository>(repository);
  getIt.registerSingleton<StorageService>(storage);
  getIt.registerSingleton<SharedPreferences>(prefs);

  UserService userService = UserService();
  getIt.registerSingleton<UserService>(userService);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
