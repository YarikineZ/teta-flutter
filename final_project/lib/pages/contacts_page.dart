import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/data/repository/user_repository.dart';
import 'package:messenger/main.dart';

import '../models/user.dart';
import 'chat_page.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(contactsScreeenProvider);
    final UserRepository userRepository = GetIt.I.get<UserRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed:
                ref.read(contactsScreeenProvider.notifier).showAddContactWindow,
          )
        ],
      ),
      body: StreamBuilder(
          stream: userRepository.usersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final List<User>? usersList = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  reverse: false,
                  itemCount: usersList?.length,
                  itemBuilder: (context, index) {
                    return UserCardWidget(user: usersList![index]);
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("No users in DB"),
              );
            }
          }),
      bottomSheet: pageController.isAdding ? const BottomAddContact() : null,
    );
  }
}

class UserCardWidget extends StatelessWidget {
  final User user;
  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        ListTile(
          leading: CircleAvatar(child: Text(user.displayName[0])),
          title: Text(user.displayName),
          onTap: () {
            //Material анимация
            // Navigator.of(context).push(CupertinoPageRoute(
            //     builder: ((context) =>
            //         ChatPage(pageTitle: user.displayName!))));
            Navigator.of(context)
                .push(_createRoute(ChatPage(pageTitle: user.displayName)));
          },
        ),
      ],
    );
  }
}

//анимация перехода между страницами
Route _createRoute(Widget to) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => to,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class BottomAddContact extends ConsumerWidget {
  const BottomAddContact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(contactsScreeenProvider);

    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: ref
                    .read(contactsScreeenProvider.notifier)
                    .textEditingController,
                decoration:
                    const InputDecoration(labelText: 'Paste contact UUID'),
                onChanged: (_) => ref
                    .read(contactsScreeenProvider.notifier)
                    .controlAddContactbutton(),
              ),
            ),
            TextButton(
                onPressed: pageController.isAddCintactButtonActive
                    ? ref.read(contactsScreeenProvider.notifier).addContact
                    : null,
                child: Icon(
                  Icons.add_rounded,
                  color: ref
                          .watch(contactsScreeenProvider.notifier)
                          .textEditingController
                          .text
                          .isEmpty
                      ? Colors.grey
                      : null,
                )),
            TextButton(
              onPressed: ref
                  .read(contactsScreeenProvider.notifier)
                  .hideAddContactWindow,
              child: const Icon(
                Icons.arrow_drop_down,
              ),
            )
          ],
        ),
      ),
    );
  }
}
