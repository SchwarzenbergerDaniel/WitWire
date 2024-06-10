import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:witwire/date_methods.dart';

class QueryHelper {
  static late Timestamp uploadTimeToday;
  static void initQueryHelper() async {
    uploadTimeToday = await DateMethods.getTimeStampByKey(
        DateMethods.getKeyByDate(DateTime.now()));
  }

  static Query<Map<String, dynamic>> _getPostQueryByDay(DateTime postTime) {
    DateTime postDate = DateTime(postTime.year, postTime.month, postTime.day);
    DateTime nextDay = postDate.add(const Duration(days: 1));
    return FirebaseFirestore.instance
        .collection('posts')
        .where('day', isGreaterThanOrEqualTo: Timestamp.fromDate(postDate))
        .where('day', isLessThan: Timestamp.fromDate(nextDay));
  }

  static Query<Map<String, dynamic>> getYesterDayQuery() {
    DateTime now = DateTime.now();
    DateTime postTime;
    now.compareTo(uploadTimeToday.toDate()) < 0
        ? postTime = now.add(const Duration(days: -2))
        : postTime = now.add(const Duration(days: -1));

    return _getPostQueryByDay(postTime);
  }

  static Query<Map<String, dynamic>> getTodayQuery() {
    DateTime now = DateTime.now();
    DateTime postTime;
    now.compareTo(uploadTimeToday.toDate()) > 0
        ? postTime = now
        : postTime = now.add(const Duration(days: -1));

    return _getPostQueryByDay(postTime);
  }
}
