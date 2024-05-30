import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:witwire/firebaseParser/userData.dart';

class PostMethods {
  static void uploadPost(
      String photoURL, String uid, String username, String description) async {
    List<String> hashTags = _getHashTags(description);

    DateTime today = DateTime.now();
    CollectionReference postsCollection =
        FirebaseFirestore.instance.collection("posts");
    postsCollection.add({
      'comments': [],
      'date': today,
      'description': description,
      'hashtags': hashTags,
      'imageURL': photoURL,
      'likes': 1,
      'uid': uid,
      'votes': {uid: true},
      'username': UserData.currentLoggedInUser!.username,
      'profilePictureURL': UserData.currentLoggedInUser!.photoURL
    });

    //User updaten
    FirebaseFirestore.instance.collection("users").doc(uid).set({
      "lastupload": DateTime.now(),
    }, SetOptions(merge: true));
    UserData.currentLoggedInUser!
        .setUser(); //Daten des users haben sich geändert.
  }

  static List<String> _getHashTags(String description) {
    List<String> asArr = description.split(RegExp(r'\s+'));
    List<String> erg = [];
    for (String word in asArr) {
      if (word.length > 1 && word[0] == '#') {
        erg.add(word.substring(1));
      }
    }
    return erg;
  }
}
