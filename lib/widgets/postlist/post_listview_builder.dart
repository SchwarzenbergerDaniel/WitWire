import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/widgets/post/post.dart';
import 'package:witwire/widgets/postlist/nodata_widget.dart';

enum SortingType { normal, top, least, mostcomments, newest, oldest }

//TODO: User auswählen lassen welcher SortingType

class PostListViewBuilder extends StatelessWidget {
  late final Query<Map<String, dynamic>> postQuery;
  late final ScrollController controller;
  bool isSortable;
  SortingType type = SortingType.normal;

  PostListViewBuilder(
      {required this.postQuery,
      required this.controller,
      required this.isSortable,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Auswahl wonach sortiert werden soll

        //Posts
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: type == SortingType.normal || !isSortable
                ? getNormalStream()
                : type == SortingType.top
                    ? getTopStream()
                    : type == SortingType.least
                        ? getBottomStream()
                        : type == SortingType.newest
                            ? getNewestStream()
                            : getMostCommentsStream(),
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
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNormalStream() {
    return postQuery.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTopStream() {
    return postQuery.orderBy('likes', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBottomStream() {
    return postQuery.orderBy('likes', descending: false).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMostCommentsStream() {
    //TODO: sort by most comments
    return null!;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNewestStream() {
    return postQuery.orderBy('date', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOldestStream() {
    return postQuery.orderBy('date', descending: false).snapshots();
  }
}
