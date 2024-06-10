import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/widgets/post/post.dart';
import 'package:witwire/widgets/postlist/nodata_widget.dart';

// ignore: must_be_immutable
class PostListViewBuilder extends StatelessWidget {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> postStream;
  late ScrollController controller;

  PostListViewBuilder(
      {required this.postStream, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const NoDataWidget();
        }
        final posts = snapshot.data!.docs;
        if (posts.isEmpty) return const NoDataWidget();

        return ListView.builder(
          itemCount: posts.length,
          shrinkWrap: true,
          controller: controller,
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
