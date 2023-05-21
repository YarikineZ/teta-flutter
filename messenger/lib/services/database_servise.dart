import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  Future getData(firebaseApp) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: firebaseApp);
    DatabaseReference ref = database.ref();

    final snapshot = await ref.child('message').get();

    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }
}
