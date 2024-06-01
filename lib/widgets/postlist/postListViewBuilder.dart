import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/widgets/post/post.dart';

class PostListViewBuilder extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> postStream;

  PostListViewBuilder({required this.postStream, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data!.docs;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Post(
                post: PostData.getPostDataFromSnapshot(posts[index]),
              ),
            );
          },
        );
      },
    );
  }
}
