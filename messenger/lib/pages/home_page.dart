﻿import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb hide PhoneAuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:messenger/pages/settings_page.dart';
import 'package:messenger/pages/settings_page_riverpod.dart';
import 'chats_list_page.dart';
import 'contacts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (fb.FirebaseAuth.instance.currentUser != null) {
        setState(() {
          _selectedIndex = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ContactsPage(),
    ChatsPage(),
    SettingsPageR()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
