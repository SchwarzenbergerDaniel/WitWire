import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/logik/queryhelper.dart';
import 'package:witwire/widgets/appbar/friends_and_chat_appbar.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/post_listview_builder.dart';

class TodayTopFeed extends StatefulWidget {
  const TodayTopFeed({super.key});

  @override
  State<TodayTopFeed> createState() => _TodayTopFeedState();
}

class _TodayTopFeedState extends State<TodayTopFeed> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FriendsAndChatAppBar(),
      body: PostListViewBuilder(
          isSortable: true,
          postQuery: getStream(),
          controller: scrollController),
      bottomNavigationBar: BottomNavBar(3),
    );
  }

  Query<Map<String, dynamic>> getStream() {
    return QueryHelper.getTodayQuery().orderBy('likes', descending: true);
  }
}
