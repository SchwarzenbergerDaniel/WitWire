import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/widgets/post/post.dart';
import 'package:witwire/widgets/postlist/nodata_widget.dart';

enum SortingType { normal, top, least, mostcomments, newest, oldest }

//TODO: User auswählen lassen welcher SortingType

class PostListViewBuilder extends StatefulWidget {
  final Query<Map<String, dynamic>> postQuery;
  final ScrollController controller;
  final bool isSortable;

  const PostListViewBuilder(
      {required this.postQuery,
      required this.controller,
      required this.isSortable,
      super.key});

  @override
  State<PostListViewBuilder> createState() => _PostListViewBuilderState();
}

class _PostListViewBuilderState extends State<PostListViewBuilder> {
  SortingType type = SortingType.normal;

  void _changeSortingType(SortingType type) {
    if (type != this.type) {
      setState(() {
        this.type = type;
      });
    }
  }

  Widget _buildDropDownMenu() {
    return DropdownMenu(
      label: const Text("Sortiere"),
      enableSearch: false,
      onSelected: (index) {
        if (index != null) {
          switch (index) {
            case 0:
              _changeSortingType(SortingType.normal);
              break;
            case 1:
              _changeSortingType(SortingType.top);
              break;
            case 2:
              _changeSortingType(SortingType.least);
              break;
            case 3:
              _changeSortingType(SortingType.mostcomments);
              break;
            case 4:
              _changeSortingType(SortingType.newest);
              break;
            case 5:
              _changeSortingType(SortingType.oldest);
              break;
            default:
          }
        }
      },
      dropdownMenuEntries: const <DropdownMenuEntry<int>>[
        DropdownMenuEntry(value: 0, label: ""),
        DropdownMenuEntry(value: 1, label: "Top"),
        DropdownMenuEntry(value: 2, label: "Bottom"),
        DropdownMenuEntry(value: 3, label: "Meisten Kommentare"),
        DropdownMenuEntry(value: 4, label: "Neueste"),
        DropdownMenuEntry(value: 5, label: "Älteste")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        //Auswahl wonach sortiert werden soll
        _buildDropDownMenu(),
        //Posts
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: type == SortingType.normal || !widget.isSortable
                ? getNormalStream()
                : type == SortingType.top
                    ? getTopStream()
                    : type == SortingType.least
                        ? getBottomStream()
                        : type == SortingType.newest
                            ? getNewestStream()
                            : type == SortingType.oldest
                                ? getOldestStream()
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
                controller: widget.controller,
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
    return widget.postQuery.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTopStream() {
    return widget.postQuery.orderBy('likes', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBottomStream() {
    return widget.postQuery.orderBy('likes', descending: false).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMostCommentsStream() {
    return widget.postQuery
        .orderBy('commentCount', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNewestStream() {
    return widget.postQuery.orderBy('date', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOldestStream() {
    return widget.postQuery.orderBy('date', descending: false).snapshots();
  }
}
