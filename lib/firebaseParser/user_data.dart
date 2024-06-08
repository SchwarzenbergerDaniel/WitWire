import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static UserData? _currentLoggedInUser;
  static UserData? get currentLoggedInUser => _currentLoggedInUser;

  static Future<bool> initLoggedInUser() async {
    _currentLoggedInUser =
        UserData(uid: FirebaseAuth.instance.currentUser!.uid, dontSet: true);
    await _currentLoggedInUser!.setUser();
    return true;
  }

  static Future<QueryDocumentSnapshot<Object?>> getUserByUID(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    return querySnapshot.docs.first;
  }

  late String email;
  late String uid;
  String username = "";
  String bio = "";
  late String photoURL;
  late List followers;
  late List following;
  late Timestamp lastupload;

  UserData({required this.uid, bool? dontSet}) {
    if (dontSet != true) {
      setUser();
    }
  }

  setUser() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> asMap = (snap.data() as Map<String, dynamic>);
    email = asMap["email"];
    username = asMap["username"];
    bio = asMap["description"];
    followers = asMap["followers"];
    following = asMap["following"];
    lastupload = asMap["lastupload"];
    photoURL = asMap["photoURL"];
  }

  bool isFollowing(String uid) {
    return followers.contains(uid);
  }

  void followUser(String uid) {}

  void unfollowUser(String uid) {}
}
