import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserChatPreview extends StatefulWidget {
  late String userID;
  UserChatPreview({super.key, required this.userID});

  @override
  State<UserChatPreview> createState() => _UserChatPreviewState(userID: userID);
}

class _UserChatPreviewState extends State<UserChatPreview> {
  late String userID;

  _UserChatPreviewState({required String this.userID});

  @override
  Widget build(BuildContext context) {
    //TODO: links: Bild als Kreis, rechts: Name des Users.
    //Onclick: Zum Chat redirecten.
    return GestureDetector();
  }
}
