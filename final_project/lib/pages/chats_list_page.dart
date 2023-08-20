import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/pages/chat_page.dart';
import 'package:messenger/services/realtime_db_servise.dart';
import 'package:messenger/services/user_service.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/chat.dart';
import '../models/user.dart';

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
    final RealtimeDbService realtimeDbService =
        GetIt.I.get<RealtimeDbService>();
    final UserService userService = GetIt.I.get<UserService>();
    User opponent =
        realtimeDbService.getContactFromChat(chat.id, userService.user.id);

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(child: Image.network(opponent.photoURL)),
          title: Text(opponent.displayName),
          subtitle: Text(chat.lastmessage),
          trailing: Text(
            timeago.format(DateTime.fromMillisecondsSinceEpoch(chat.timestamp)),
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black38,
                fontSize: 13.0),
          ),
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: ((context) => ChatPage(chat: chat))));
          },
        ),
        const Divider(height: 0),
      ],
    );
  }
}
