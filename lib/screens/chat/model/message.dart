import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String receiver;
  Timestamp time;
  String message;

  Message(
      {required this.sender,
      required this.receiver,
      required this.time,
      required this.message});

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "receiver": receiver,
      "time": time,
      "message": message
    };
  }
}
