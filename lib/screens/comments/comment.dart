import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
            Row(
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(timeToShow)
              ],
            ),
            Text(comment),
          ],
        )
      ],
    );
  }
}
