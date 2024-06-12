import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:witwire/date_methods.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/logik/image_storage_methods.dart';
import 'package:witwire/logik/post_methods.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/home/home_screen.dart';
import 'package:witwire/utils/colors.dart';

// ignore: must_be_immutable
class UserUploadScreen extends StatefulWidget {
  Uint8List image;
  UserUploadScreen({required this.image, super.key});

  @override
  State<UserUploadScreen> createState() => _UserUploadScreenState();
}

class _UserUploadScreenState extends State<UserUploadScreen> {
  void _upload() async {
    ImageStorageMethods.uploadPostPicture(widget.image).then((photoURL) {
      String uid = UserData.currentLoggedInUser!.uid;
      String username = UserData.currentLoggedInUser!.username;
      String description = _beschreibungscontroller.text;
      DateMethods.getTimeStampByKey(DateMethods.getKeyByDate(DateTime.now()))
          .then((value) => PostMethods.uploadPost(photoURL, uid, username,
              description, value.toDate().isBefore(DateTime.now())));
    });

    navigatorKey.currentState!.pushAndRemoveUntil(
        //Keine möglichkeit geben zurück zu gehen.
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }

  final TextEditingController _beschreibungscontroller =
      TextEditingController();
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.5;
    if (imageWidth > 175) {
      imageWidth = 175;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
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
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isUploading == true
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                              backgroundImage: Image.network(
                            UserData.currentLoggedInUser!.photoURL,
                          ).image),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _beschreibungscontroller,
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(215, 215, 215, 1),
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
                        height: MediaQuery.of(context).size.height * 0.7,
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
