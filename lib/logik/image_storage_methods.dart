import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageStorageMethods {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<String> uploadProfilePicture(Uint8List img) async {
    const String folderName = "profilePictures";

    Reference ref =
        _storage.ref().child(folderName).child(_auth.currentUser!.uid);
    UploadTask task = ref.putData(img);
    TaskSnapshot sn = await task;

    String url = await sn.ref.getDownloadURL();

    return url;
  }

  static Future<String> uploadPostPicture(Uint8List img) async {
    const String folderName = "postPictures";

    Reference ref =
        _storage.ref().child(folderName).child(_auth.currentUser!.uid);
    UploadTask task = ref.putData(img);
    TaskSnapshot sn = await task;

    String url = await sn.ref.getDownloadURL();

    return url;
  }
}
