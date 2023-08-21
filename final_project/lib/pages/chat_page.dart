import 'package:get_it/get_it.dart';
import 'package:messenger/services/user_service.dart';

import '../data/repository/user_repository.dart';
import '../models/chat.dart';
import '../models/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';
import 'package:flutter/material.dart';
import 'package:messenger/services/realtime_db_servise.dart';

class ChatPage extends StatelessWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  final defaultAvatarURL =
      "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: Image.network(defaultAvatarURL,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("ERR"),
                    loadingBuilder: (context, Widget widget,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return widget;
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ));
                    }).image),
            Text(chat.title),
          ],
        ),
      ),
      body: MessagesList(chat: chat),
      bottomSheet: MyBottomSheet(chat: chat),
    );
  }
}

class MessagesList extends StatefulWidget {
  final Chat chat;
  const MessagesList({super.key, required this.chat});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late bool _isShimmer;
  @override
  Widget build(BuildContext context) {
    final RealtimeDbService database = GetIt.I.get<RealtimeDbService>();

    return StreamBuilder(
        stream: database.messagesStream(widget.chat.id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              _isShimmer = true;
              break;
            case ConnectionState.done:
            case ConnectionState.active:
              _isShimmer = false;
              break;
          }

          return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 10, 16.0, 80),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.ease,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isShimmer
                    ? const MessagesShimmer()
                    : showMessages(snapshot),
              ));
        });
  }

  Widget showMessages(snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      final List<Message>? messageList = snapshot.data;
      return ListView.builder(
          key: const ValueKey('showMessages'),
          reverse: false,
          itemCount: messageList?.length,
          itemBuilder: (context, index) {
            return MessageWidget(message: messageList![index]);
          });
    } else {
      return const Center(child: Text("No messages"));
    }
  }
}

class MessagesShimmer extends StatefulWidget {
  const MessagesShimmer({super.key});

  @override
  State<MessagesShimmer> createState() => _MessagesShimmerState();
}

class _MessagesShimmerState extends State<MessagesShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        child: ListView.builder(
          key: const ValueKey('showMessagesShimmer'),
          reverse: false,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                    height: 50,
                    width: 360,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 199, 255, 201),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )));
          },
        ),
        builder: (BuildContext context, Widget? child) {
          Color twColor1 = Colors.white;
          Color twColor2 = Colors.grey.shade300;

          Animation anOne =
              ColorTween(begin: twColor1, end: twColor2).animate(_controller);
          Animation anTwo =
              ColorTween(begin: twColor2, end: twColor1).animate(_controller);

          return ShaderMask(
            blendMode: BlendMode.modulate,
            shaderCallback: (rect) {
              return LinearGradient(colors: [anOne.value, anTwo.value])
                  .createShader(rect);
            },
            child: child,
          );
        });
  }
}

class MessageWidget extends StatelessWidget {
  final UserService userService = GetIt.I.get<UserService>();
  final Message message;

  MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: message.userId == userService.user.id
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: message.userId == userService.user.id
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
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
          const SizedBox(height: 8),
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
  final Chat chat;

  const MyBottomSheet({super.key, required this.chat});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  bool _isMic = true;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(_checkAndChangeIcon);
    _controller.addListener(_checkAndChangeIcon);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: myFocusNode,
                style: const TextStyle(fontSize: 16.0),
                decoration: const InputDecoration(
                  labelText: "Message",
                  // border: OutlineInputBorder(),
                  // floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.ease,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _isMic ? _micIcon() : _sendIcon())
          ],
        ),
      ),
    );
  }

  Widget _micIcon() {
    return IconButton(
      key: const ValueKey('micIcon'),
      onPressed: () {
        myFocusNode.unfocus();
      },
      icon: const Icon(Icons.mic),
    );
  }

  Widget _sendIcon() {
    UserService userService = GetIt.I.get<UserService>();
    final RealtimeDbService database = GetIt.I.get<RealtimeDbService>();

    return IconButton(
      key: const ValueKey('sendIcon'),
      onPressed: () {
        myFocusNode.unfocus();
        _controller.text.isNotEmpty || _controller.text != ""
            ? {
                database.sendMessage(
                    userService.user.id, widget.chat.id, _controller.text)
              }
            : null;
        _controller.text = "";
      },
      highlightColor: Colors.green,
      icon: const Icon(Icons.send),
    );
  }

  void _checkAndChangeIcon() {
    bool tagetIsMic =
        _controller.text != "" && myFocusNode.hasFocus ? false : true;

    if (tagetIsMic != _isMic) {
      setState(() {
        _isMic = tagetIsMic;
      });
    }
  }
}
