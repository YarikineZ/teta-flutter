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
    // чтобы не писать as SettingsPageModel указал явный тип при инициализации провайдера ;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          pageController.isEdit
              ? TextButton(
                  onPressed: () =>
                      ref.read(settingsScreeenProvider.notifier).done(),
                  // onPressed: () => ref.read(settingsScreeenProvider.notifier).update((state) => "null"),
                  child: const Text("Done"))
              : TextButton(
                  onPressed: () =>
                      ref.read(settingsScreeenProvider.notifier).edit(),
                  child: const Text("Edit"))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  ref.read(settingsScreeenProvider.notifier).pickImage(),
              child: CircleAvatar(
                  radius: 32, child: Image.network(pageController.avatarURL)),
            ),
            const SizedBox(height: 32.0),
            pageController.isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField(
                      controller: ref
                          .read(settingsScreeenProvider.notifier)
                          .textEditingController,
                      decoration:
                          const InputDecoration(labelText: 'Enter Your name'),
                    ))
                : Text(pageController.userName),
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
