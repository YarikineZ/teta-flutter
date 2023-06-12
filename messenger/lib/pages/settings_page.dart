import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEdit = false;

  void _edit() {
    setState(() {
      _isEdit = true;
    });
  }

  void _done() {
    setState(() {
      _isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          _isEdit
              ? TextButton(onPressed: _edit, child: Text("Done"))
              : TextButton(onPressed: _edit, child: Text("Edit"))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            CircleAvatar(
              child: Icon(Icons.face),
              radius: 32,
            ),
            SizedBox(height: 32.0),
            _isEdit
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField())
                : Text("No name")
          ],
        ),
      ),
    );
  }
}
