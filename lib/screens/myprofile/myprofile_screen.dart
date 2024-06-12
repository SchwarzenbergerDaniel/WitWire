import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/loginRegister/login_screen.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/post_listview_builder.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ScrollController _controller = ScrollController();
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
        actions: [
          ElevatedButton(onPressed: _signOut, child: const Text("Ausloggen"))
        ],
      ),
      body: PostListViewBuilder(
        isSortable: true,
        controller: _controller,
        postQuery: getStream(),
      ),
      bottomNavigationBar: BottomNavBar(4),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Query<Map<String, dynamic>> getStream() {
    return FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: UserData.currentLoggedInUser!.uid);
  }
}
