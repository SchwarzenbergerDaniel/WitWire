import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/userData.dart';

class PostData {
  String postID;
  late String uid;
  late String username;
  late String description;
  late int likes;
  late bool canBeLiked;
  late String imagePath;
  late int currentUserLike;
  late DateTime publishedTime;
  late List hashtags;
  PostData({required this.postID, required this.canBeLiked}) {
    setPost();
  }

  void setPost() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('posts').doc(postID).get();
    Map<String, dynamic> asMap = (snap.data() as Map<String, dynamic>);

    uid = asMap["uid"];
    username = asMap["username"];
    likes = asMap["likes"];
    imagePath = asMap["imageURL"];
    description = asMap["description"];
    publishedTime = asMap["date"];
    hashtags = asMap["hashtags"];

    Map<String, dynamic> votes = asMap["votes"] ?? {};

    String currentUserUID = UserData.currentLoggedInUser!.uid;
    if (votes.containsKey(currentUserUID)) {
      bool userVote = votes[currentUserUID];
      currentUserLike = userVote ? 1 : 2;
    } else {
      currentUserLike = 0;
    }
  }
}
