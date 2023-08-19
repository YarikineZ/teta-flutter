import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/services/realtime_db_servise.dart';
import 'package:messenger/services/user_service.dart';

import '../data/repository/user_repository.dart';
import '../models/chat.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = GetIt.I.get<UserService>();
    final RealtimeDbService realtimeDbService =
        GetIt.I.get<RealtimeDbService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: StreamBuilder(
          stream: realtimeDbService.myChatsStream(userService.user.id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final List<Chat>? chatsList = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  reverse: false,
                  itemCount: chatsList?.length,
                  itemBuilder: (context, index) {
                    return ChatCard(chat: chatsList![index]);
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("No chats in DB"),
              );
            }
          }),
    );
  }
}

class ChatCard extends StatelessWidget {
  final Chat chat;
  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(chat.title),
          subtitle: Text(chat.lastmessage),
          onTap: () {
            // Navigator.of(context).push(CupertinoPageRoute(
            //     builder: ((context) => ContactPage(contact: user))));
          },
        ),
        const Divider(height: 0),
      ],
    );
  }
}
