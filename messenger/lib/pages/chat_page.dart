import 'package:get_it/get_it.dart';
import 'package:messenger/services/shared_preferences_service.dart';

import '../models/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';
import 'package:flutter/material.dart';
import 'package:messenger/services/database_servise.dart';

class ChatPage extends StatefulWidget {
  final String pageTitle;
  const ChatPage({super.key, required this.pageTitle});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: const MessagesList(),
      bottomSheet: const MyBottomSheet(),
    );
    return scaffold;
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DatabaseService database = GetIt.I.get<DatabaseService>();

    return StreamBuilder(
        stream: database.messagesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<Message>? messageList = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                reverse: false,
                itemCount: messageList?.length,
                itemBuilder: (context, index) {
                  return MessageWidget(message: messageList![index]);
                },
              ),
            );
          } else {
            return const Center(
              child: Text("No messages"),
            );
          }
        });
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              message.userId,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(
                  StringToHex.toColor(
                    message.userId,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              timeago.format(
                DateTime.fromMillisecondsSinceEpoch(
                  message.timestamp,
                ),
              ),
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                  fontSize: 13.0),
            )
          ]),
          const SizedBox(
            height: 8,
          ),
          Text(
            message.text,
            style: const TextStyle(fontSize: 16.0),
          )
        ],
      ),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({
    super.key,
  });

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  late Widget animatedIcon;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(_checkAndChangeIcon);
    _controller.addListener(_checkAndChangeIcon);
    animatedIcon = _micIcon();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // onTap: _changeIconToSend,
              controller: _controller,
              focusNode: myFocusNode,
              style: const TextStyle(fontSize: 16.0),
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
          AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              switchInCurve: Curves.ease,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: animatedIcon)
        ],
      ),
    );
  }

  Widget _micIcon() {
    return IconButton(
      key: UniqueKey(),
      onPressed: () {
        myFocusNode.unfocus();
      },
      icon: const Icon(Icons.mic),
    );
  }

  Widget _sendIcon() {
    final SharedPreferencesService sharedPreferences =
        GetIt.I.get<SharedPreferencesService>();
    final DatabaseService database = GetIt.I.get<DatabaseService>();

    return IconButton(
      key: UniqueKey(),
      onPressed: () {
        myFocusNode.unfocus();
        _controller.text.isNotEmpty || _controller.text != ""
            ? database.sendMessage(sharedPreferences.uuid, _controller.text)
            : null;
        _controller.text = "";
      },
      icon: const Icon(Icons.send),
    );
  }

  void _checkAndChangeIcon() {
    Widget targetIcon = _controller.text != "" && myFocusNode.hasFocus
        ? _sendIcon()
        : _micIcon();

    if (targetIcon != animatedIcon) {
      setState(() {
        animatedIcon = targetIcon;
      });
    }
  }
}
