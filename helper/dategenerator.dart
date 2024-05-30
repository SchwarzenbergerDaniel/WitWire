import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebase_options.dart';
import 'package:witwire/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
