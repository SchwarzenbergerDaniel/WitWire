import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/postListViewBuilder.dart';

class ShowUser extends StatelessWidget {
  const ShowUser({required this.user, super.key});

  final QueryDocumentSnapshot<Object?> user;

  @override
  Widget build(BuildContext context) {
    print("BUILD SHOW USER");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: mainColor,
        backgroundColor: secondaryColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: Image.network(
                user["photoURL"],
                fit: BoxFit.cover,
              ).image,
            ),
            const SizedBox(width: 20),
            Text(user["username"], style: const TextStyle(color: mainColor)),
          ],
        ),
      ),
      body: PostListViewBuilder(
        postStream: getStream(),
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    //TODO: ERROR AT WHERE
    return FirebaseFirestore.instance
        .collection("posts")
        // .where("uid", isEqualTo: user["uid"])
        .orderBy("date", descending: true)
        .snapshots();
  }
}
