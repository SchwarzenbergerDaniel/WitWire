import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageStorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadProfilePicture(Uint8List img) async {
    const String folderName = "profilePictures";

    Reference ref =
        _storage.ref().child(folderName).child(_auth.currentUser!.uid);
    UploadTask task = ref.putData(img);
    TaskSnapshot sn = await task;

    String url = await sn.ref.getDownloadURL();

    return url;
  }

  Future<String> uploadPostPicture(Uint8List img) async {
    const String folderName = "postPictures";

    Reference ref =
        _storage.ref().child(folderName).child(_auth.currentUser!.uid);
    UploadTask task = ref.putData(img);
    TaskSnapshot sn = await task;

    String url = await sn.ref.getDownloadURL();

    return url;
  }
}
