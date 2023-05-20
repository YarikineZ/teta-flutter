import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  //FirebaseDatabase database = FirebaseDatabase.instance;

  Future getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final snapshot = await ref.child('message').get();

    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }
}
