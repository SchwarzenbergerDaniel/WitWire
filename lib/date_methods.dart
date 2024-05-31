import 'package:cloud_firestore/cloud_firestore.dart';

class DateMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<Timestamp> getTimeStampByKey(String key) async {
    DocumentReference ref = firestore.collection('dates').doc(key);
    DocumentSnapshot snap = await ref.get();
    Timestamp timestamp = (snap.data() as Map<String, dynamic>)['date'];
    return timestamp;
  }

  static String getKeyByDate(DateTime day) {
    return "${day.year}-${day.month}-${day.day}";
  }
}
