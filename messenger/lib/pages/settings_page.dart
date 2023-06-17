import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';

import '../services/database_servise.dart';
import '../services/storage_servise.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEdit = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _edit(SharedPreferencesService sharedPreferences) {
    setState(() {
      _isEdit = true;
      _controller.text = sharedPreferences.name;
    });
  }

  void _done(
      SharedPreferencesService sharedPreferences, DatabaseService database) {
    setState(() {
      _isEdit = false;
      sharedPreferences.saveNewName(_controller.text);
      database.updateUser(sharedPreferences.uuid, _controller.text,
          sharedPreferences.avatarURL);
    });
  }

  void pickImage(
      StorageService storage,
      SharedPreferencesService sharedPreferences,
      DatabaseService database) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String downloadURL = await storage.pushImage(image.name, image.path);
      sharedPreferences.setAvatarURL(downloadURL);
      database.updateUser(
          sharedPreferences.uuid, sharedPreferences.name, downloadURL);
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
    final DatabaseService database = context.read<DatabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          _isEdit
              ? TextButton(
                  onPressed: () => _done(sharedPreferences, database),
                  child: const Text("Done"))
              : TextButton(
                  onPressed: () => _edit(sharedPreferences),
                  child: const Text("Edit"))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => pickImage(storage, sharedPreferences, database),
              child: CircleAvatar(
                  radius: 32,
                  child: Image.network(sharedPreferences
                      .avatarURL)), //TODO make background image
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
