import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:messenger/pages/settings_page.dart';
import 'package:messenger/pages/chats_list_page.dart';
import 'package:messenger/pages/contacts_page.dart';
import 'package:messenger/main.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    ContactsPage(),
    ChatsPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(homeScreeenProvider);

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(pageController.selectedIndex),
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
          currentIndex: pageController.selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) => ref
              .read(homeScreeenProvider.notifier)
              .updateSelectedIndex(index)),
    );
  }
}
