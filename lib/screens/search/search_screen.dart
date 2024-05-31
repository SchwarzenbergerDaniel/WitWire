import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/widgets/appbar/search_appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchScreenAppBar(
        controller: _controller,
        onchanged: inputChanged,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  void inputChanged(String text) {
    print(text);
  }
}
