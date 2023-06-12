import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/services/storage_servise.dart';
import 'package:provider/provider.dart';

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

  void _done(storage) {
    setState(() {
      _isEdit = false;
      storage.saveNewName(_controller.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StorageService storage = context.read<StorageService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          _isEdit
              ? TextButton(
                  onPressed: () => _done(storage), child: const Text("Done"))
              : TextButton(onPressed: _edit, child: const Text("Edit"))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const CircleAvatar(
              child: Icon(Icons.face),
              radius: 32,
            ),
            const SizedBox(height: 32.0),
            _isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Enter Your name'),
                    ))
                : Text(storage.name)
          ],
        ),
      ),
    );
  }
}
