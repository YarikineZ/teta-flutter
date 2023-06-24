import 'package:flutter/material.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/pages/chat_page.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() => runApp(const MyApp());

final _plugins = initializePlugins(
  contentsSidePanel: true,
  knobsSidePanel: true,
  initialDeviceFrameData: DeviceFrameData(
    device: Devices.ios.iPhone13,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
        initialStory: 'Screens/Scaffold',
        plugins: _plugins,
        stories: [
          Story(
            name: 'Chat screen',
            builder: (context) {
              final knobsMessage = Message(
                  text: context.knobs
                      .text(label: "Message text", initial: "Message text"),
                  userId: context.knobs.text(label: "UserId", initial: "12345"),
                  timestamp: context.knobs.sliderInt(
                      label: "Time", initial: 1687637290, max: 1687637290));

              return Center(child: MessageWidget(message: knobsMessage));
            },
          ),
        ],
      );
}
