import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/widgets/post/post.dart';
import 'package:witwire/widgets/postlist/nodata_widget.dart';

enum SortingType { normal, top, least, mostcomments, newest, oldest }

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
  List<QueryDocumentSnapshot> posts = [];
  bool isLoading = false;
  bool hasMore = true;
  final int pageSize = 10;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener);
    _loadMorePosts();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.controller.position.pixels ==
        widget.controller.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  void _changeSortingType(SortingType type) {
    if (type != this.type) {
      setState(() {
        this.type = type;
        posts.clear();
        lastDocument = null;
        hasMore = true;
        _loadMorePosts();
      });
    }
  }

  Future<void> _loadMorePosts() async {
    print("LOAD");
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    Query<Map<String, dynamic>> query = _getQuery();
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    final snapshot = await query.limit(pageSize).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        posts.addAll(snapshot.docs);
        lastDocument = snapshot.docs.last;
        if (snapshot.docs.length < pageSize) {
          hasMore = false;
        }
      });
    } else {
      setState(() {
        hasMore = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Query<Map<String, dynamic>> _getQuery() {
    switch (type) {
      case SortingType.top:
        return widget.postQuery.orderBy('likes', descending: true);
      case SortingType.least:
        return widget.postQuery.orderBy('likes', descending: false);
      case SortingType.mostcomments:
        return widget.postQuery.orderBy('commentCount', descending: true);
      case SortingType.newest:
        return widget.postQuery.orderBy('date', descending: true);
      case SortingType.oldest:
        return widget.postQuery.orderBy('date', descending: false);
      case SortingType.normal:
      default:
        return widget.postQuery;
    }
  }

  Widget _buildDropDownMenu() {
    return Align(
      alignment: Alignment.center,
      child: DropdownButton<int>(
        value: type.index,
        items: const [
          DropdownMenuItem(value: 0, child: Text("Normal")),
          DropdownMenuItem(value: 1, child: Text("Top")),
          DropdownMenuItem(value: 2, child: Text("Bottom")),
          DropdownMenuItem(value: 3, child: Text("Most Comments")),
          DropdownMenuItem(value: 4, child: Text("Newest")),
          DropdownMenuItem(value: 5, child: Text("Oldest")),
        ],
        onChanged: (index) {
          if (index != null) {
            _changeSortingType(SortingType.values[index]);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildDropDownMenu(),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == posts.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListTile(
                title: Post(
                  post: PostData.getPostDataFromSnapshot(posts[index]),
                ),
              );
            },
            childCount: posts.length + (hasMore ? 1 : 0),
          ),
        ),
      ],
    );
  }
}
