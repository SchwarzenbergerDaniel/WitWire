import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/chat/chatscreen/chat_screen.dart';
import 'package:witwire/screens/myprofile/myprofile_screen.dart';
import 'package:witwire/screens/userlist_displayer/userlist_displayer.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbar.dart';
import 'package:witwire/widgets/postlist/post_listview_builder.dart';

// ignore: must_be_immutable
class ShowUser extends StatefulWidget {
  bool _isMyProfile = false;
  late bool _isFollowed;
  UserData? _user;

  ShowUser({required this.user, super.key}) {
    if (user["uid"] == UserData.currentLoggedInUser!.uid) {
      _isMyProfile = true;
    }
    _isFollowed = UserData.currentLoggedInUser!.isFollowing(user["uid"]);
    _user = UserData(uid: user["uid"]);
  }

  final QueryDocumentSnapshot<Object?> user;

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  Widget _buildGoToChatButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(tuerkiscolor),
            foregroundColor: MaterialStatePropertyAll(Colors.black),
          ),
          onPressed: () => {
                if (widget._user != null)
                  {
                    navigatorKey.currentState!.push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(user: widget._user!),
                      ),
                    ),
                  }
              },
          child: const Text("Nachricht")),
    );
  }

  Widget _buildFollowButton() {
    return SizedBox(
      width: 200,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              widget._isFollowed ? Colors.grey : tuerkiscolor),
          foregroundColor: const MaterialStatePropertyAll(Colors.black),
        ),
        onPressed: widget._isFollowed ? _unfollow : _follow,
        child: widget._isFollowed
            ? const Text("Deabonniere")
            : const Text("Abonniere"),
      ),
    );
  }

  void _follow() {
    UserData.currentLoggedInUser!.followUser(widget._user!.uid);
    setState(() {
      widget._isFollowed = true;
    });
  }

  void _unfollow() {
    UserData.currentLoggedInUser!.unfollowUser(widget._user!.uid);

    setState(() {
      widget._isFollowed = false;
    });
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget._isMyProfile) {
      return const MyProfileScreen();
    }
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        Image.network(widget.user["photoURL"]).image,
                  ),
                ]),
                const SizedBox(width: 25),
                Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => navigatorKey.currentState!.push(
                            MaterialPageRoute(
                              builder: (context) => UserListScreen(
                                  uids: widget.user["followers"],
                                  title: "Abonniert"),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.user["followers"].length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Abonnenten",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        InkWell(
                          onTap: () => navigatorKey.currentState!.push(
                            MaterialPageRoute(
                              builder: (context) => UserListScreen(
                                  uids: widget.user["following"],
                                  title: "Abonnenten"),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.user["following"].length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Abonniert",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildFollowButton(),
                    const SizedBox(height: 10),
                    _buildGoToChatButton(),
                  ],
                ),
              ],
            ),
            PostListViewBuilder(
              isSortable: true,
              controller: _controller,
              postQuery: getStream(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }

  Query<Map<String, dynamic>> getStream() {
    return FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: widget.user["uid"]);
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      foregroundColor: mainColor,
      backgroundColor: secondaryColor,
      title: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: Image.network(
              widget.user["photoURL"],
              fit: BoxFit.cover,
            ).image,
          ),
          const SizedBox(width: 20),
          Text(widget.user["username"],
              style: const TextStyle(color: mainColor)),
        ],
      ),
    );
  }
}
