import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/showUser/showUser.dart';

class UserPrevOnClickProfile extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> user;
  late final String username;
  late final String photoURL;
  late final String description;
  late final String uid;
  UserPrevOnClickProfile({super.key, required this.user}) {
    username = user["username"];
    photoURL = user["photoURL"];
    description = user["description"];
    uid = user["uid"];
  }

  void goToProfile() async {
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (context) => ShowUser(user: user),
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
