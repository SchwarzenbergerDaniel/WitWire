import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:witwire/firebaseParser/postData.dart';
import 'package:witwire/logik/getLastDayPosts.dart';
import 'package:witwire/providers/newdayprovider.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/appbar/friendsAndChatAppbar.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/post/post.dart';

class ShowNextUploadScreen extends StatefulWidget {
  const ShowNextUploadScreen({super.key});

  @override
  State<ShowNextUploadScreen> createState() => _ShowNextUploadScreenState();
}

class _ShowNextUploadScreenState extends State<ShowNextUploadScreen> {
  String getTimeToDisplayByMinutes(int seconds) {
    String hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    String remainingMinutes =
        ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    String remainingSeconds = (seconds % 60).toString().padLeft(2, '0');

    return "$hours:$remainingMinutes:$remainingSeconds\n";
  }

  _ShowNextUploadScreenState() {
    setUp();
  }
  void setUp() async {
    topPost = await LastDayPosts.getTopPost();
    setState(() {
      topPost = topPost;
    });
  }

  PostData? topPost;
  @override
  Widget build(BuildContext context) {
    return Consumer<NewDayProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: const FriendsAndChatAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Column(
                  children: [
                    value.minuteUntilNewPost == null
                        ? const CircularProgressIndicator(color: darkColor)
                        : Text(
                            getTimeToDisplayByMinutes(
                                value.minuteUntilNewPost!),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const Text(
                      "Gestriger Top-Post:",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    topPost == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Post(post: topPost!),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(2),
      ),
    );
  }
}
