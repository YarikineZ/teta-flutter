import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts")),
      body: ListView(children: [
        Divider(height: 0),
        ListTile(
          leading: CircleAvatar(child: Text('B')),
          title: Text('Headline'),
          subtitle: Text(
              'Longer supporting text to demonstrate how the text wraps and how the leading and trailing widgets are centered vertically with the text.'),
          trailing: Icon(Icons.favorite_rounded),
        ),
        Divider(height: 0),
        ListTile(
          leading: CircleAvatar(child: Text('C')),
          title: Text('Headline'),
          subtitle: Text(
              "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
          trailing: Icon(Icons.favorite_rounded),
          isThreeLine: true,
        )
      ]),
    );
  }
}
