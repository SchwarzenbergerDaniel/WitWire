import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/myprofile/myprofile_screen.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/postListViewBuilder.dart';

class ShowUser extends StatelessWidget {
  bool _isMyProfile = false;
  ShowUser({required this.user, super.key}) {
    if (user["uid"] == UserData.currentLoggedInUser!.uid) {
      _isMyProfile = true;
    }
  }

  final QueryDocumentSnapshot<Object?> user;

  @override
  Widget build(BuildContext context) {
    if (_isMyProfile) {
      return const MyProfileScreen();
    }
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
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("date", descending: true)
        .where("uid", isEqualTo: user["uid"])
        .snapshots();
  }
}
