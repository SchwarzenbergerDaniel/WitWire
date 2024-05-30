import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:witwire/firebaseParser/userData.dart';

// ignore: must_be_immutable
class UserUploadScreen extends StatefulWidget {
  Uint8List image;
  UserUploadScreen({required this.image, super.key});

  @override
  State<UserUploadScreen> createState() => _UserUploadScreenState();
}

class _UserUploadScreenState extends State<UserUploadScreen> {
  void _upload() {}

  final TextEditingController _beschreibungscontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.5;
    if (imageWidth > 175) {
      imageWidth = 175;
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/appbar-image.png',
          fit: BoxFit.fill,
          width: imageWidth,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _upload,
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          UserData.currentLoggedInUser!.profilePicture.image,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _beschreibungscontroller,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 216, 215, 215),
                          hintText: "Beschreibung",
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Image.memory(
                    widget.image,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
