import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/postListViewBuilder.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                UserData.currentLoggedInUser!.photoURL,
                fit: BoxFit.cover,
              ).image,
            ),
            const SizedBox(width: 20),
            Text(UserData.currentLoggedInUser!.username,
                style: const TextStyle(color: mainColor)),
          ],
        ),
      ),
      body: PostListViewBuilder(
        postStream: getStream(),
      ),
      bottomNavigationBar: BottomNavBar(4),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("date", descending: true)
        .where("uid", isEqualTo: UserData.currentLoggedInUser!.uid)
        .snapshots();
  }
}
