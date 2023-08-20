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
    // чтобы не писать as SettingsPageModel указал явный тип при инициализации провайдера ;

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
