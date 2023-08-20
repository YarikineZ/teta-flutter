import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/user.dart';
import '../services/realtime_db_servise.dart';
import '../services/user_service.dart';

class ContactPage extends StatelessWidget {
  final User contact;
  ContactPage({super.key, required this.contact});

  final UserService userService = GetIt.I.get<UserService>();
  final RealtimeDbService realtimeDbService = GetIt.I.get<RealtimeDbService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact")),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(radius: 32, child: Image.network(contact.photoURL)),
          const SizedBox(height: 32.0),
          Text(contact.displayName),
          const SizedBox(height: 32.0),
          Text("UUID: ${contact.id}"),
          TextButton(
              onPressed: () {
                // Navigator.of(context).push(CupertinoPageRoute(
                //     builder: ((context) => ChatPage(chat: contact))));
                realtimeDbService.startNewChat(userService.user.id, contact.id);
              },
              child: const Text("Написать контакту")),
          TextButton(onPressed: () {}, child: const Text("Удалить контакт"))
        ]),
      ),
    );
  }
}
