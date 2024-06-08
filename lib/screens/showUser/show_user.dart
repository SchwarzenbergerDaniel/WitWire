import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/screens/myprofile/myprofile_screen.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/postListViewBuilder.dart';

// ignore: must_be_immutable
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: Image.network(user["photoURL"]).image,
              ),
              const SizedBox(width: 50),
              Column(
                children: [
                  Text(
                    user["followers"].length.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Abonnenten",
                  ),
                ],
              ),
              const SizedBox(width: 50),
              Column(
                children: [
                  Text(
                    user["following"].length.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Abonniert",
                  ),
                ],
              ),
            ],
          ),
          PostListViewBuilder(
            postStream: getStream(),
          ),
        ],
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

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }
}
