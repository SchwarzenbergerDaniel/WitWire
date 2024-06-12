import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/comments/comment_screen.dart';
import 'package:witwire/screens/search/search_screen.dart';
import 'package:witwire/screens/showUser/show_user.dart';
import 'package:witwire/utils/colors.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final PostData _post;

  const Post({required PostData post, super.key}) : _post = post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() {
    super.initState();
  }

  void _goToProfile() async {
    QueryDocumentSnapshot<Object?> a =
        await UserData.getUserByUID(widget._post.uid);
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (context) => ShowUser(user: a),
    ));
  }

  String getTimeDiffToShow() {
    Duration diff = DateTime.now().difference(widget._post.publishedTime);

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

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Ersteller, Datum
          InkWell(
            onTap: () => _goToProfile(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: Image.network(
                    widget._post.profilePictureURL,
                    fit: BoxFit.cover,
                  ).image,
                ),
                const SizedBox(width: 10),
                Text(
                  widget._post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(getTimeDiffToShow()),
              ],
            ),
          ),

          //Beschreibung
          const SizedBox(height: 5),
          buildDescriptionWidget(),

          const SizedBox(height: 5),
          //Bild:
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Container(
                color: mainColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.network(
                    widget._post.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          //Like, dislike, kommentare

          Row(
            children: [
              const SizedBox(width: 10),
              widget._post.currentUserLike == 1
                  ? IconButton(
                      onPressed: likePressed, //Ist geliked
                      icon: const Icon(Icons.arrow_upward),
                      color: Colors.deepOrange)
                  : IconButton(
                      onPressed: likePressed,
                      icon: const Icon(Icons.arrow_upward),
                    ),
              Text(
                "${widget._post.likes}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget._post.currentUserLike == 1
                        ? Colors.deepOrange
                        : widget._post.currentUserLike == -1
                            ? Colors.deepPurple
                            : Colors.black),
              ),
              widget._post.currentUserLike == -1
                  ? IconButton(
                      onPressed: dislikePressed, //ist ein dislike
                      icon: const Icon(Icons.arrow_downward),
                      color: Colors.deepPurple)
                  : IconButton(
                      onPressed: dislikePressed,
                      icon: const Icon(Icons.arrow_downward),
                    ),
              IconButton(
                onPressed: goToComments,
                icon: const Icon(Icons.chat_bubble_outline),
              ),
              Text(widget._post.commentCount.toString()),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDescriptionWidget() {
    final isLongText = widget._post.description.length > 100;

    if (!isLongText) {
      return _buildRichText(widget._post.description);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichText(
          isExpanded
              ? widget._post.description
              : '${widget._post.description.substring(0, 100)}...',
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Weniger' : 'Mehr',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  RichText _buildRichText(String text) {
    const fontSize = 18.0;
    final List<InlineSpan> children = [];
    final RegExp hashtagRegExp = RegExp(r'(#[a-zA-Z0-9_]+)');
    final matches = hashtagRegExp.allMatches(text);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Colors.black),
        ));
      }
      children.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              searchHashTag(match.group(0)!);
            },
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      children.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: Colors.black),
      ));
    }

    return RichText(
      text: TextSpan(children: children),
    );
  }

  void searchHashTag(String word) {
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          startSearch: word,
        ),
      ),
    );
  }

  void goToComments() async {
    QuerySnapshot<Map<String, dynamic>> comments = await FirebaseFirestore
        .instance
        .collection('posts')
        .doc(widget._post.postID)
        .collection('comments')
        .get();
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => Comments(
          comments: comments,
          postID: widget._post.postID,
        ),
      ),
    );
  }

  void likePressed() {
    widget._post.currentUserLike != 1
        ? widget._post.setCurrentUserLike(1)
        : widget._post.setCurrentUserLike(0);
    setState(() {
      widget._post.currentUserLike = widget._post.currentUserLike;
    });
  }

  void dislikePressed() {
    widget._post.currentUserLike != -1
        ? widget._post.setCurrentUserLike(-1)
        : widget._post.setCurrentUserLike(0);
    setState(() {
      widget._post.currentUserLike = widget._post.currentUserLike;
    });
  }
}
