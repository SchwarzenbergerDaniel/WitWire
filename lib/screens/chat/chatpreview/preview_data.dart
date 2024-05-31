import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:witwire/firebaseParser/user_data.dart';

class Preview {
  UserData user;
  Timestamp time;
  String lastMessage;
  Preview({required this.user, required this.time, required this.lastMessage});
}
