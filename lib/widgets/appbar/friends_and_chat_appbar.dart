import 'package:flutter/material.dart';
import 'package:witwire/screens/chat/chatpreview/chat_preview_list.dart';
import 'package:witwire/screens/friends/showfriends_screen.dart';
import 'package:witwire/utils/colors.dart';

class FriendsAndChatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FriendsAndChatAppBar({super.key});
  void showFriends(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShowFriendsScreen(),
      ),
    );
  }

  void jumpToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatPreviewList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.5;
    if (imageWidth > 175) {
      imageWidth = 175;
    }
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: brightColor,
            onPressed: () => showFriends(context),
            iconSize: 30,
            icon: const Icon(Icons.people),
          ),
          Image.asset('assets/appbar-image.png',
              fit: BoxFit.fill, width: imageWidth),
          IconButton(
            color: brightColor,
            onPressed: () => jumpToChat(context),
            iconSize: 30,
            icon: const Icon(Icons.chat),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(56.0); // Adjust height as needed
}
