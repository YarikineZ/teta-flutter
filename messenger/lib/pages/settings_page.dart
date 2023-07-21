import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:messenger/services/user_service.dart';

import '../services/storage_servise.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEdit = false;
  final TextEditingController _controller = TextEditingController();
  UserService userService = GetIt.I.get<UserService>();

  @override
  void initState() {
    super.initState();
  }

  void _edit(UserService userService) {
    setState(() {
      _isEdit = true;
      _controller.text = userService.user.displayName;
    });
  }

  void _done(UserService userService) {
    setState(() {
      _isEdit = false;
      userService.setName(_controller.text);
    });
  }

  void pickImage(StorageService storage, UserService userService) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String downloadURL = await storage.pushImage(image.name, image.path);
      userService.setAvatar(downloadURL);
    }
  }

  void signOut() async {
    //TODO проверить нужен ли тут асинк
    await FirebaseUIAuth.signOut();
    Navigator.pushNamed(context, '/phone');
    GetIt.I.unregister<UserService>();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StorageService storage = GetIt.I.get<StorageService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          _isEdit
              ? TextButton(
                  onPressed: () => _done(userService),
                  child: const Text("Done"))
              : TextButton(
                  onPressed: () => _edit(userService),
                  child: const Text("Edit"))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => pickImage(storage, userService),
              child: CircleAvatar(
                  radius: 32,
                  child: Image.network(
                      userService.user.photoURL)), //TODO make background image
            ),
            const SizedBox(height: 32.0),
            _isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(labelText: 'Enter Your name'),
                    ))
                : Text(userService.user.displayName),
            TextButton(
              onPressed: signOut,
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
