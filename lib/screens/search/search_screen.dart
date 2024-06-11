import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/logik/queryhelper.dart';
import 'package:witwire/widgets/appbar/friends_and_chat_appbar.dart';
import 'package:witwire/widgets/appbar/search_appbar.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/post_listview_builder.dart';
import 'package:witwire/widgets/userpreviews/userprevOnClickProfile.dart';

class SearchScreen extends StatefulWidget {
  final String? startSearch;
  const SearchScreen({this.startSearch, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    if (widget.startSearch != null) _searchText = widget.startSearch!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FriendsAndChatAppBar(),
      body: Column(
        children: [
          SearchScreenAppBar(
              controller: _controller,
              hintText:
                  widget.startSearch != null ? widget.startSearch! : "Suche...",
              onchanged: (text) => {
                    setState(() {
                      _searchText = text;
                    })
                  }),
          _searchText.startsWith('#') == false
              ? Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: getProfileStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: Text("Kein Profil gefunden!"));
                      }

                      final users = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: UserPrevOnClickProfile(user: users[index]),
                          );
                        },
                      );
                    },
                  ),
                )
              : PostListViewBuilder(
                  isSortable: true,
                  postQuery: getPostStream(),
                  controller: _scrollController),
        ],
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }

  Query<Map<String, dynamic>> getPostStream() {
    String hashTag = _searchText.length > 1 ? _searchText.substring(1) : "";
    return QueryHelper.getTodayQuery()
        .where('hashtags', arrayContains: hashTag);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProfileStream() {
    return _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: _searchText)
        .where('username', isLessThanOrEqualTo: '${_searchText}z')
        .orderBy('usernamelength')
        .snapshots();
  }
}
