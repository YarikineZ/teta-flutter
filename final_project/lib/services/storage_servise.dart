import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

//flutterfire configure

class StorageService with ChangeNotifier {
  late Reference imagesRef;

  Future init(FirebaseApp firebaseApp) async {
    imagesRef = FirebaseStorage.instance.ref().child("images");
  }

  Future<String> pushImage(String imageName, String imagePath) async {
    Reference ref = imagesRef.child(imageName);
    var imageFile = File(imagePath);
    await ref.putFile(imageFile);
    final downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
