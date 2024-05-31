import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/appbar/friends_and_chat_appbar.dart';
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
      backgroundColor: mainColor,
      body: Center(
        child: Image.network(UserData.currentLoggedInUser!.photoURL),
      ),
      bottomNavigationBar: BottomNavBar(0),
    );
  }
}
