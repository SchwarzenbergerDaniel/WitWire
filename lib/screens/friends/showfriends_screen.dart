import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/screens/userlist_displayer/userlist_displayer.dart';

class ShowFriendsScreen extends StatefulWidget {
  const ShowFriendsScreen({super.key});

  @override
  State<ShowFriendsScreen> createState() => _ShowFriendsScreenState();
}

class _ShowFriendsScreenState extends State<ShowFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    var list = UserData.currentLoggedInUser!.followers
        .intersection(UserData.currentLoggedInUser!.following)
        .toList();
    list.remove(UserData.currentLoggedInUser!.uid);
    return UserListScreen(uids: list, title: "Freunde");
  }
}
