import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: ListView(children: const [
        ListTile(
          leading: CircleAvatar(child: Text('B')),
          title: Text('Chat with user 1'),
          subtitle: Text("hello!"),
          trailing: Text("5 hours ago"),
        ),
        Divider(height: 0),
        ListTile(
          leading: CircleAvatar(child: Text('B')),
          title: Text('Chat with user 2'),
          subtitle: Text("hello!"),
          trailing: Text("5 hours ago"),
        ),
        Divider(height: 0),
        ListTile(
          leading: CircleAvatar(child: Text('B')),
          title: Text('Chat with user 3'),
          subtitle: Text("hello!"),
          trailing: Text("5 hours ago"),
        ),
        Divider(height: 0),
      ]),
    );
  }
}
