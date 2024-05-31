import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/chat/chatpreview/preview_data.dart';
import 'package:witwire/screens/chat/chatscreen/chat_screen.dart';

// ignore: must_be_immutable
class ChatPreview extends StatefulWidget {
  late UserData user;
  late String time;
  late String lastMessage;
  ChatPreview({super.key, required Preview prevData}) {
    user = prevData.user;
    lastMessage = prevData.lastMessage;
    setTime(prevData.time.toDate());
  }

  void setTime(DateTime t) {
    Duration diff = DateTime.now().difference(t);

    int days = diff.inDays;
    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;

    if (days > 0) {
      time = '${days}d';
    } else if (hours > 0) {
      time = '${hours}h ${minutes}m';
    } else {
      time = '${minutes}m';
    }
  }

  @override
  State<ChatPreview> createState() => _ChatPreviewState();
}

class _ChatPreviewState extends State<ChatPreview> {
  void goToChat() {
    if (!loading) {
      navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (context) => ChatScreen(user: widget.user),
      ));
    }
  }

  bool loading = true;
  @override
  void initState() {
    super.initState();
    widget.user.setUser().then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.grey,
      onTap: () => goToChat(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
        child: SizedBox(
          height: 50,
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          Image.network(widget.user.photoURL, fit: BoxFit.cover)
                              .image,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.username,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Text(
                              widget.lastMessage,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(widget.time))
                  ],
                ),
        ),
      ),
    );
  }
}
