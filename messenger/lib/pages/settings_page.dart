import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';

import '../services/storage_servise.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEdit = false;
  final TextEditingController _controller = TextEditingController();

  void _edit() {
    setState(() {
      _isEdit = true;
    });
  }

  void _done(sharedPreferences) {
    setState(() {
      _isEdit = false;
      sharedPreferences.saveNewName(_controller.text);
    });
  }

  void pickImage(StorageService storage,
      SharedPreferencesService sharedPreferences) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String downloadURL = await storage.pushImage(image.name, image.path);
      sharedPreferences.setAvatarURL(downloadURL);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SharedPreferencesService sharedPreferences =
        context.read<SharedPreferencesService>(); //context.read??
    final StorageService storage = context.read<StorageService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          _isEdit
              ? TextButton(
                  onPressed: () => _done(sharedPreferences),
                  child: const Text("Done"))
              : TextButton(onPressed: _edit, child: const Text("Edit"))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => pickImage(storage, sharedPreferences),
              child: CircleAvatar(
                radius: 32,
                child: Image.network(
                    sharedPreferences.avatarURL), //TODO make background image
              ),
            ),
            const SizedBox(height: 32.0),
            _isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Enter Your name'),
                    ))
                : Text(sharedPreferences.name)
          ],
        ),
      ),
    );
  }
}
