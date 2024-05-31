import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/screens/chat/model/message.dart';
import 'package:witwire/utils/colors.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.user});
  UserData user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState();

  final TextEditingController _nachrichtController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nachrichtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Chat von user und dem Userdata.Loggedinuser anzeigen.
    //Sammlung: chats,
    //Dokument: ID des loggedin users.
    //Inhalt:

    return Scaffold(
      appBar: AppBar(
        foregroundColor: brightColor,
        backgroundColor: darkColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: Image(
                image: widget.user.profilePicture.image,
                fit: BoxFit.cover,
              ).image,
            ),
            const SizedBox(width: 20),
            Text(widget.user.username,
                style: const TextStyle(color: brightColor)),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          //Nachrichten:
          Expanded(child: _buildMessageList()),
          const SizedBox(
            height: 20,
          ),
          //Eingabefeld:
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  height: 50.0,
                  child: Center(
                    // Center the text vertically
                    child: TextField(
                      controller: _nachrichtController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Nachricht',
                      ),
                    ),
                  ),
                )),
                IconButton(
                  onPressed: sendeNachricht,
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMessageList() {
    return StreamBuilder(
      stream: getMessages(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Wart amal...");
        }

        return ListView(
          children: snapshot.data!.docs.map((e) => messageListTile(e)).toList(),
        );
      }),
    );
  }

  DateTime? lastMessageTimeStamp;
  Widget messageListTile(DocumentSnapshot snap) {
    Map<String, dynamic> map = snap.data() as Map<String, dynamic>;
    bool showDay = lastMessageTimeStamp == null;
    DateTime time = (map['time'] as Timestamp).toDate();
    if (showDay == false &&
        (time.year != lastMessageTimeStamp!.year ||
            time.month != lastMessageTimeStamp!.month ||
            time.day != lastMessageTimeStamp!.day)) {
      showDay = true;
    }
    bool isRight = map["sender"] == UserData.currentLoggedInUser!.uid;
    Alignment alignment;
    Color messageColor;
    if (isRight) {
      alignment = Alignment.centerRight;
      messageColor = messageSenderColor;
    } else {
      alignment = Alignment.centerLeft;
      messageColor = messageReceiverColor;
    }
    lastMessageTimeStamp = time;
    return Column(
      children: [
        showDay == true
            ? Text(
                "${time.day}.${time.month}.${time.year}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
            : const SizedBox(height: 0),
        Align(
          alignment: alignment,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: messageColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              map["message"],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
  //LOGIK:

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection("chats")
        .doc(getChatRoomID())
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<void> sendeNachricht() async {
    String nachricht = _nachrichtController.text;
    _nachrichtController.clear();
    if (nachricht.isEmpty) return;
    Message m = Message(
        sender: UserData.currentLoggedInUser!.uid,
        receiver: widget.user.uid,
        time: Timestamp.now(),
        message: nachricht);

    String chatRoomID = getChatRoomID();
    await _firestore
        .collection("chats")
        .doc(chatRoomID)
        .collection("messages")
        .add(m.toMap());
    await _firestore.collection("chats").doc(chatRoomID).set(
        {'lastmessagetime': Timestamp.now(), 'lastmessagecontent': nachricht});
  }

  String getChatRoomID() {
    List<String> room = [widget.user.uid, UserData.currentLoggedInUser!.uid];
    room.sort();
    return "${room[0]}-${room[1]}";
  }
}
