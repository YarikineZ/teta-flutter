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

class MessagesList extends StatefulWidget {
  const MessagesList({
    super.key,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late bool _isShimmer;
  @override
  Widget build(BuildContext context) {
    final DatabaseService database = GetIt.I.get<DatabaseService>();

    return StreamBuilder(
        stream: database.messagesStream(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              _isShimmer = true;
              break;
            // break;
            case ConnectionState.done:
            case ConnectionState.active:
              _isShimmer = false;
            // break;
          }

          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.ease,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isShimmer
                    ? const MessagesShimmer()
                    // : showMessages(snapshot)
                    : const MessagesShimmer(),
              ));

          // child: _isShimmer ? showShimmer() : showMessages(snapshot));
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
  late Animation anOne;
  late Animation anTwo;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    Color twColor1 = Colors.white;
    Color twColor2 = Colors.grey.shade300;

    anOne = ColorTween(begin: twColor1, end: twColor2).animate(_controller);
    anTwo = ColorTween(begin: twColor2, end: twColor1).animate(_controller);
    _controller.forward();

    _controller.addListener(() {
      if (_controller.isCompleted) _controller.reverse();
      if (_controller.isDismissed) _controller.forward();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const ValueKey('showMessagesShimmer'),
      reverse: false,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ShaderMask(
              blendMode: BlendMode.modulate,
              shaderCallback: (rect) {
                return LinearGradient(colors: [anOne.value, anTwo.value])
                    .createShader(rect);
              },
              child: Container(
                  height: 50,
                  width: 360,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 199, 255, 201),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  )),
            ));
      },
    );
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
  const MyBottomSheet({
    super.key,
  });

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
    return Padding(
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
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
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
    final SharedPreferencesService sharedPreferences =
        GetIt.I.get<SharedPreferencesService>();
    final DatabaseService database = GetIt.I.get<DatabaseService>();

    return IconButton(
      key: const ValueKey('sendIcon'),
      onPressed: () {
        myFocusNode.unfocus();
        _controller.text.isNotEmpty || _controller.text != ""
            ? database.sendMessage(sharedPreferences.uuid, _controller.text)
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
