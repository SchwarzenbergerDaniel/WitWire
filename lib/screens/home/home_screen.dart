import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/userData.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/appbar/friendsAndChatAppbar.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FriendsAndChatAppBar(),
      backgroundColor: brightColor,
      body: Center(
        child: UserData.currentLoggedInUser!.profilePicture,
      ),
      bottomNavigationBar: BottomNavBar(0),
    );
  }
}
