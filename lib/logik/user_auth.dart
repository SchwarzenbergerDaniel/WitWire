import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:witwire/date_methods.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/logik/image_storage_methods.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _userCollectionName = "users";

  static Future<bool> uploadedToday(UserData data) async {
    //Schauen, ob es zwischen der Upload-Zeit von gestern und heute ist oder zwischen der von heute und morgen
    DateTime now = DateTime.now();
    Timestamp today =
        await DateMethods.getTimeStampByKey(DateMethods.getKeyByDate(now));
    Timestamp yesterday = await DateMethods.getTimeStampByKey(
        DateMethods.getKeyByDate(now.add(const Duration(days: -1))));

    Timestamp lastUpload = UserData.currentLoggedInUser!.lastupload;
    Timestamp nowStamp = Timestamp.now();

    if (lastUpload.compareTo(today) > 0) {
      //Upload war heute schon.
      return true;
    }

    if (today.compareTo(nowStamp) > 0) {
      //Upload heute zu späteren Zeitpunkt
      if (lastUpload.compareTo(yesterday) > 0) {
        //Schauen ob gestern hochgeladen wurde
        return true;
      }
    }
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
      if (username.length > 20) {
        return "Maximal 20 Zeichen im Username";
      }

      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String userID = user.user!.uid;

      String url = await ImageStorageMethods.uploadProfilePicture(file);

      await _firestore.collection(_userCollectionName).doc(userID).set({
        'username': username,
        'uid': userID,
        'email': email,
        'description': beschreibung,
        'followers': [],
        'following': [],
        'photoURL': url,
        'password': password,
        'usernamelength': username.length,
        'lastupload': DateTime.now().add(const Duration(days: -2))
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
