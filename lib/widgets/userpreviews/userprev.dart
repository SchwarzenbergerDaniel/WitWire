import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/chat/chatscreen/chat_screen.dart';

class UserPrev extends StatelessWidget {
  QueryDocumentSnapshot<Object?> user;
  late String username;
  late String photoURL;
  late String description;
  late String uid;
  UserPrev({super.key, required this.user}) {
    username = user["username"];
    photoURL = user["photoURL"];
    description = user["description"];
    uid = user["uid"];
  }

  void goToProfile() async {
    UserData user = UserData(uid: uid);
    await user.setUser();
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (context) => ChatScreen(user: user),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: InkWell(
        onTap: goToProfile,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: Image.network(photoURL, fit: BoxFit.cover).image,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Flexible(
                    child: Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
