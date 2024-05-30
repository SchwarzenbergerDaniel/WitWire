import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData {
  static UserData? _currentLoggedInUser;
  static UserData? get currentLoggedInUser => _currentLoggedInUser;

  static Future<bool> initLoggedInUser() async {
    _currentLoggedInUser =
        UserData(uid: FirebaseAuth.instance.currentUser!.uid, dontSet: true);
    await _currentLoggedInUser!.setUser();
    return true;
  }

  late String email;
  late String uid;
  Image profilePicture = Image.network(
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSibZzICT3UJ_BuQBQZehq1tmBwrWZ6v7-rSQ&s');
  String username = "";
  String bio = "";
  late String photoURL;
  late List followers;
  late List following;

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

    photoURL = asMap["photoURL"];
    profilePicture = Image.network(photoURL);
  }
}
