import 'package:cloud_firestore/cloud_firestore.dart';

class PostMethods {
  static void uploadPost(
      String photoURL, String uid, String username, String description) async {
    List<String> hashTags = _getHashTags(description);

    await FirebaseFirestore.instance.collection("posts").doc().set({
      'comments': [],
      'date': DateTime.now(),
      'description': description,
      'hashtags': hashTags,
      'imageURL': photoURL,
      'likes': 1,
      'uid': uid,
      'votes': {uid: true}
    });
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
