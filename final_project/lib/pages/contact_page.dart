import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'chat_page.dart';

class ContactPage extends StatelessWidget {
  final User contact;
  const ContactPage({super.key, required this.contact});

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
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: ((context) =>
                        ChatPage(pageTitle: contact.displayName))));
              },
              child: const Text("Написать контакту")),
          TextButton(onPressed: () {}, child: const Text("Удалить контакт"))
        ]),
      ),
    );
  }
}
