import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/userpreviews/userprevOnClickProfile.dart';

class UserListScreen extends StatefulWidget {
  final List uids;
  final String title;
  const UserListScreen({required this.uids, required this.title, super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List _searchedItems = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchedItems = widget.uids;
    });
  }

  void filter(String searchText) {
    List results = [];
    if (searchText.isEmpty) {
      results = widget.uids;
    } else {
      results = widget.uids
          .where((element) =>
              element.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      results.sort((a, b) => b.length - a.length);
    }

    setState(() {
      _searchedItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                filter(value);
              },
              decoration: const InputDecoration(
                labelText: "Search",
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchedItems.length,
                itemBuilder: (context, index) {
                  final name = _searchedItems[index];
                  return FutureBuilder<Widget>(
                    future: getWIdgetbyUID(name),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Wart amal...");
                      }
                      return snapshot.data!;
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }

  Future<Widget> getWIdgetbyUID(String uid) async {
    QueryDocumentSnapshot doc = await UserData.getUserByUID(uid);

    return UserPrevOnClickProfile(user: doc);
  }
}
