import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:witwire/logik/imageStorageMethods.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _userCollectionName = "users";

  static Future<bool> uploadedToday(String uid) async {
    //TODO IMPLEMENT THIS METHOD.
    return false;
  }

  static Future<String> createNewUser(
      {required String email,
      required String password,
      required String username,
      required String beschreibung,
      required Uint8List file}) async {
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          beschreibung.isEmpty) {
        return "Fülle alle Felder aus!";
      }
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String userID = user.user!.uid;

      String url = await ImageStorageMethods().uploadProfilePicture(file);

      await _firestore.collection(_userCollectionName).doc(userID).set({
        'username': username,
        'uid': userID,
        'email': email,
        'description': beschreibung,
        'followers': [],
        'following': [],
        'photoURL': url,
        'password': password
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> login(String mail, String password) async {
    try {
      if (mail.isEmpty || password.isEmpty) return "Fülle alle Felder aus!";
      await _auth.signInWithEmailAndPassword(email: mail, password: password);
      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}
