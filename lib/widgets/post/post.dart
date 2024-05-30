import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/postData.dart';
import 'package:witwire/firebaseParser/userData.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  PostData _post;
  Post({required PostData post, super.key}) : _post = post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          //Ersteller, Datum
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: Image(
                  image: UserData.currentLoggedInUser!.profilePicture.image,
                  fit: BoxFit.cover,
                ).image,
              ),
              Column(
                children: [
                  Text(
                    _post.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _post.publishedTime.toString(),
                  ),
                ],
              )
            ],
          ),

          //Bild:
          Container(
            color: Colors.grey,
            child: Image.network(_post.imagePath,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
