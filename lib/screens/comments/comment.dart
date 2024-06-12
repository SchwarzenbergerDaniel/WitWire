import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/search/search_screen.dart';

class PostComment extends StatelessWidget {
  final QueryDocumentSnapshot snap;
  const PostComment({required this.snap, super.key});

  String getTimeDiffToShow() {
    Duration diff =
        DateTime.now().difference((snap["time"] as Timestamp).toDate());

    int days = diff.inDays;
    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;

    if (days > 0) {
      return '${days}d';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _onClick() {
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: ((context) => SearchScreen(
              startSearch: snap["username"],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String comment = snap["comment"];
    String timeToShow = getTimeDiffToShow();
    String photoURL = snap["photoURL"];
    String username = snap["username"];

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          foregroundImage: Image.network(photoURL).image,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _onClick,
              child: Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(timeToShow)
                ],
              ),
            ),
            Text(comment),
          ],
        )
      ],
    );
  }
}
