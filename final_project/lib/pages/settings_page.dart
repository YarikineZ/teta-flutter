import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  final defaultAvatarURL =
      "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(settingsScreeenProvider);
    ref
        .read(settingsScreeenProvider.notifier)
        .updateStateAfterUserServiceInit();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          pageController.isEdit
              ? TextButton(
                  onPressed: () =>
                      ref.read(settingsScreeenProvider.notifier).done(),
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
                onTap: () => pageController.isEdit == true
                    ? ref.read(settingsScreeenProvider.notifier).pickImage()
                    : null,
                child: CircleAvatar(
                    radius: 32,
                    child: Image.network(pageController.avatarURL,
                        // scale: 0.71, //чтобы картинка вмещалась в круг. Не работает
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
                        }))),
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
                onPressed: () async => {
                      await FirebaseUIAuth.signOut(),
                      Navigator.pushNamed(context, '/phone')
                    },
                child: const Text("Sign Out")),
            TextButton(
                onPressed: () =>
                    ref.read(settingsScreeenProvider.notifier).copyUUID(),
                child: const Text("Copy my UUID")),
          ],
        ),
      ),
      bottomSheet: pageController.isSnackBar ? const SnackBar() : null,
    );
  }
}

class SnackBar extends ConsumerWidget {
  const SnackBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox(
      height: 50,
      child: Center(
        child: Text("UUID Copied"),
      ),
    );
  }
}
