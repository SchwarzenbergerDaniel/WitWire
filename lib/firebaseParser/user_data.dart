import 'dart:collection';

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
  late HashSet<String> followers;
  late HashSet<String> following;
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
    print("MAP: " + asMap.toString());
    email = asMap["email"];
    username = asMap["username"];
    bio = asMap["description"];
    followers = HashSet.from(asMap["followers"]);
    following = HashSet.from(asMap["following"]);
    lastupload = asMap["lastupload"];
    photoURL = asMap["photoURL"];
  }

  bool isFollowing(String uid) {
    return following.contains(uid);
  }

  void _followOtherUserChange(String otherUserID, bool isFollowing) {
    //Update currentUser following
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(uid);

    if (isFollowing) {
      userRef.update({
        'following': FieldValue.arrayUnion([otherUserID])
      });
      following.add(otherUserID);
    } else {
      userRef.update({
        'following': FieldValue.arrayRemove([otherUserID])
      });
      following.remove(otherUserID);
    }
    _otherUserFollowedChanged(otherUserID, isFollowing);
  }

  void _otherUserFollowedChanged(String otherUID, bool isFollowing) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(otherUID);

    if (isFollowing) {
      userRef.update({
        'followers': FieldValue.arrayUnion([uid])
      });
    } else {
      userRef.update({
        'followers': FieldValue.arrayRemove([uid])
      });
    }
  }

  void followUser(String uid) async {
    if (following.contains(uid)) return;

    _followOtherUserChange(uid, true);
  }

  void unfollowUser(String uid) {
    if (!following.contains(uid)) return;

    _followOtherUserChange(uid, false);
  }
}
