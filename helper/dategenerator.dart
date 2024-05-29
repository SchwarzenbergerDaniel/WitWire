import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:witwire/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAoITeh10d0TgKAZ3Chp9_7CzLQAk2h1vg",
            authDomain: "witwire-ebf8e.firebaseapp.com",
            projectId: "witwire-ebf8e",
            storageBucket: "witwire-ebf8e.appspot.com",
            messagingSenderId: "304275998023",
            appId: "1:304275998023:web:34b1651d328d02fb70f862"));
  } else {
    await Firebase.initializeApp();
  }
  await fillDates();
  runApp(const MyApp());
}

Future<void> fillDates() async {
  const int amount = 100;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Random random = Random();
  final DateTime today = DateTime.now();
  final List<Map<String, dynamic>> dates = [];

  for (int i = 0; i < amount; i++) {
    final DateTime date = today.add(Duration(
        days: i, hours: random.nextInt(24), minutes: random.nextInt(60)));
    final String key = '${date.year}-${date.month}-${date.day}';
    dates.add({
      'date': date,
      'key': key,
    });
  }

  for (int i = 0; i < dates.length; i++) {
    await firestore.collection('dates').doc(dates[i]['key']).set(dates[i]);
  }
}
