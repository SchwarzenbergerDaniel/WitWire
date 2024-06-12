import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageStorageMethods {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static Future<String> uploadProfilePicture(Uint8List img) async {
    return _uploadImage("profilePictures", img);
  }

  static Future<String> uploadPostPicture(Uint8List img) async {
    return _uploadImage("postPictures", img);
  }

  static Future<String> _uploadImage(String folderName, Uint8List img) async {
    Reference ref = _storage.ref().child(folderName).child(getRandomString(20));

    UploadTask task = ref.putData(img);
    TaskSnapshot sn = await task;
    String url = await sn.ref.getDownloadURL();

    return url;
  }

  static String getRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
