import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/widgets/appbar/search_appbar.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/userpreviews/userprev.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();
  String _searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchScreenAppBar(
        controller: _controller,
        onchanged: (text) => {
          setState(() {
            _searchText = text;
          })
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (context, snapshot) {
          print(snapshot);
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(title: UserPrev(user: users[index]));
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: _searchText)
        .where('username', isLessThanOrEqualTo: '${_searchText}z')
        .orderBy('usernamelength')
        .snapshots();
  }
}
