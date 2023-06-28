import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/user.dart';
import '../services/database_servise.dart';
import 'chat_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService database = GetIt.I.get<DatabaseService>();

    return Scaffold(
        appBar: AppBar(title: const Text("Contacts")),
        body: StreamBuilder(
            stream: database.usersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final List<User>? usersList = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    reverse: false,
                    itemCount: usersList?.length,
                    itemBuilder: (context, index) {
                      return UserCardWidget(user: usersList![index]);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text("No users in DB"),
                );
              }
            }));
  }
}

class UserCardWidget extends StatelessWidget {
  final User user;
  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        ListTile(
          leading: CircleAvatar(child: Text(user.displayName![0])),
          title: Text(user.displayName!),
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: ((context) =>
                    ChatPage(pageTitle: user.displayName!))));
          },
        ),
      ],
    );
  }
}
