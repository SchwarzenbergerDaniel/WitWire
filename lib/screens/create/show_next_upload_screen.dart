import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/logik/get_last_day_posts.dart';
import 'package:witwire/providers/newdayprovider.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/appbar/friends_and_chat_appbar.dart';
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

    mostCommentsPost = await LastDayPosts.getMostCommentsPost();
    setState(() {
      mostCommentsPost = mostCommentsPost;
    });

    firstPost = await LastDayPosts.getFirstPost();
    setState(() {
      firstPost = firstPost;
    });

    lastPost = await LastDayPosts.getLastPost();
    setState(() {
      lastPost = lastPost;
    });

    bottomPost = await LastDayPosts.getBottomPost();
    setState(() {
      bottomPost = bottomPost;
    });
  }

  PostData? topPost;
  PostData? mostCommentsPost;
  PostData? bottomPost;
  PostData? firstPost;
  PostData? lastPost;

  Widget _buildPostInfo(String text, PostData? post) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        post == null ? const Text("") : Post(post: post),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewDayProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: const FriendsAndChatAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    children: [
                      value.minuteUntilNewPost == null
                          ? const CircularProgressIndicator(
                              color: secondaryColor)
                          : Text(
                              getTimeToDisplayByMinutes(
                                  value.minuteUntilNewPost!),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                      //Top Post gestern:
                      _buildPostInfo("Top Likes:", topPost),

                      //Top Post gestern:
                      _buildPostInfo("Top Kommentiert:", mostCommentsPost),

                      //Erster Post gestern:
                      _buildPostInfo("Erster", firstPost),

                      //Letzter Post gestern:
                      _buildPostInfo("Letzter", lastPost),

                      //Wenigsten Likes
                      _buildPostInfo("Min Likes:", bottomPost),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(2),
      ),
    );
  }
}
