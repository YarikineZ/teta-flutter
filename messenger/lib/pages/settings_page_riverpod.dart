import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class SettingsPageR extends ConsumerWidget {
  const SettingsPageR({super.key});
  final defaultAvatarURL =
      "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(settingsScreeenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          ref.watch(settingsScreeenProvider).isEdit
              ? TextButton(
                  onPressed: () => pageController.done(),
                  child: const Text("Done"))
              : TextButton(
                  onPressed: () => pageController.done(),
                  child: const Text("Edit"))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => pageController.pickImage(),
              child: CircleAvatar(
                  radius: 32,
                  child: Image.network(
                      pageController.avatarURL ?? defaultAvatarURL)),
            ),
            const SizedBox(height: 32.0),
            pageController.isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField(
                      controller: pageController.textEditingController,
                      decoration:
                          const InputDecoration(labelText: 'Enter Your name'),
                    ))
                : Text(pageController.userService.user.displayName),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                  context, '/phone'), //TODO Add sign out from firebase
              child: const Text("Sign Out"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/map'),
              child: const Text("Go to Map"),
            ),
          ],
        ),
      ),
    );
  }
}
