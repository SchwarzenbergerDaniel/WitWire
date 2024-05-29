import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/create/create_screen.dart';

class NewDayProvider extends ChangeNotifier {
  int? _secondsUntilNewPost;

  int? get minuteUntilNewPost => _secondsUntilNewPost;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Timer? newPostTimer;
  Timer? secondChangedTimer;
  void setTimer() {
    newPostTimer =
        Timer(Duration(seconds: _secondsUntilNewPost!), () => newPostEvent());
    secondChangedTimer = Timer(const Duration(seconds: 1), handleSecondChanged);
  }

  void handleSecondChanged() {
    _secondsUntilNewPost = _secondsUntilNewPost! - 1;
    notifyListeners();
    secondChangedTimer?.cancel();

    secondChangedTimer = Timer(const Duration(seconds: 1), handleSecondChanged);
  }

  void sendUserToUpload() {
    if (FirebaseAuth.instance.currentUser != null) {
      //Nur, wenn der User eingeloggt ist.
      navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (context) => CreateScreen(userNeedsToUpload: true),
      ));
    }
  }

  void newPostEvent() {
    newPostTimer?.cancel();
    sendUserToUpload();
  }

  @override
  void dispose() {
    super.dispose();
    newPostTimer?.cancel();
    secondChangedTimer?.cancel();
  }

  int getDifferenceInSeconds(Timestamp postTimeStamp, DateTime now) {
    DateTime timestamp = postTimeStamp.toDate();
    Duration difference = timestamp.difference(now);
    return difference.inSeconds;
  }

  Future<Timestamp> getTimeStampByKey(String key) async {
    DocumentReference ref = firestore.collection('dates').doc(key);
    DocumentSnapshot snap = await ref.get();
    Timestamp timestamp = (snap.data() as Map<String, dynamic>)['date'];
    return timestamp;
  }

  String getKeyByDate(DateTime day) {
    return "${day.year}-${day.month}-${day.day}";
  }

  void start(BuildContext c) async {
    // Datenbank speichert in UTC+2
    final Location timeZone = getLocation('Europe/Berlin');
    DateTime now = TZDateTime.now(timeZone);
    String todayKey = getKeyByDate(now);

    DateTime tomorrow = now.add(const Duration(days: 1));
    String tomorrowKey = getKeyByDate(tomorrow);

    Timestamp todaysPostTime = await getTimeStampByKey(todayKey);

    int diffFirstInSeconds = getDifferenceInSeconds(todaysPostTime, now);
    if (diffFirstInSeconds > 0) {
      _secondsUntilNewPost = diffFirstInSeconds;
    } else {
      _secondsUntilNewPost =
          getDifferenceInSeconds(await getTimeStampByKey(tomorrowKey), now);
    }
    setTimer();
  }
}
