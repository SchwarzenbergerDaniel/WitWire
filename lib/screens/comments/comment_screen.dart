import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/screens/comments/comment.dart';
import 'package:witwire/utils/colors.dart';

class Comments extends StatefulWidget {
  late final List<QueryDocumentSnapshot> comments;
  late final String postID;
  Comments(
      {required QuerySnapshot<Map<String, dynamic>> comments,
      required this.postID,
      super.key}) {
    this.comments = comments.docs;
  }

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _controller = TextEditingController();

  List<String> myComments = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kommentare"),
        centerTitle: false,
        backgroundColor: mainColor,
        foregroundColor: secondaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...List.generate(myComments.length, (i) {
                  return ListTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          foregroundImage: Image.network(
                            UserData.currentLoggedInUser!.photoURL,
                          ).image,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  UserData.currentLoggedInUser!.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text('Jetzt'),
                              ],
                            ),
                            Text(myComments[i]),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                //Aus der Datenbank
                ListView.builder(
                  itemCount: widget.comments.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: PostComment(snap: widget.comments[index]),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Kommentiere",
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                IconButton(
                  color: Colors.blue,
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    String message = _controller.text;
    if (message.isEmpty) return;

    //In die Datenbank laden.
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postID)
        .collection('comments')
        .add({
      'comment': message,
      'username': UserData.currentLoggedInUser!.username,
      'photoURL': UserData.currentLoggedInUser!.photoURL,
      'time': DateTime.now()
    });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postID)
        .update({'commentCount': FieldValue.increment(1)});

    _controller.clear();
    setState(() {
      myComments.add(message);
    });
  }
}
