import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/logik/queryhelper.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/appbar/friends_and_chat_appbar.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/post_listview_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FriendsAndChatAppBar(),
      backgroundColor: mainColor,
      body: PostListViewBuilder(
          isSortable: true, postQuery: getStream(), controller: _controller),
      bottomNavigationBar: BottomNavBar(0),
    );
  }

  Query<Map<String, dynamic>> getStream() {
    var asList = UserData.currentLoggedInUser!.following.toList();

    return QueryHelper.getTodayQuery().where('uid', whereIn: asList);
  }
}
