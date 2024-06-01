import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/utils/colors.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final PostData _post;

  Post({required PostData post, super.key}) : _post = post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          //Ersteller, Datum
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: Image.network(
                  UserData.currentLoggedInUser!.photoURL,
                  fit: BoxFit.cover,
                ).image,
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    widget._post.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget._post.publishedTime.toString(),
                  ),
                ],
              )
            ],
          ),

          //Bild:
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Container(
                color: Colors.white, // Set the background color to white
                child: Image.network(
                  widget._post.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          //Beschreibung

          Text(widget._post.description),

          //Like, dislike, kommentare

          Row(
            children: [
              Text(
                "     ${widget._post.likes}",
                style: const TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              widget._post.currentUserLike == 1
                  ? IconButton(
                      onPressed: likePressed,
                      icon: const Icon(Icons.thumb_up_alt_rounded))
                  : IconButton(
                      onPressed: likePressed,
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                    ),
              widget._post.currentUserLike == -1
                  ? IconButton(
                      onPressed: dislikePressed,
                      icon: const Icon(Icons.thumb_down_alt_rounded))
                  : IconButton(
                      onPressed: dislikePressed,
                      icon: const Icon(Icons.thumb_down_alt_outlined),
                    ),
              IconButton(
                onPressed: goToComments,
                icon: const Icon(Icons.chat_bubble_outline),
              )
            ],
          )
        ],
      ),
    );
  }

  void goToComments() {
    //TODO:
  }

  void likePressed() {
    if (widget._post.canBeLiked == false) return;
    widget._post.currentUserLike != 1
        ? widget._post.setCurrentUserLike(1)
        : widget._post.setCurrentUserLike(0);
    setState(() {
      widget._post.currentUserLike = widget._post.currentUserLike;
    });
  }

  void dislikePressed() {
    if (widget._post.canBeLiked == false) return;

    widget._post.currentUserLike != -1
        ? widget._post.setCurrentUserLike(-1)
        : widget._post.setCurrentUserLike(0);
    setState(() {
      widget._post.currentUserLike = widget._post.currentUserLike;
    });
  }
}
