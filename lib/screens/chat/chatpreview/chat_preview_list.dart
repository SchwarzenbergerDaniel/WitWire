import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/screens/chat/chatpreview/chat_preview.dart';
import 'package:witwire/screens/chat/chatpreview/preview_data.dart';
import 'package:witwire/utils/colors.dart';

class ChatPreviewList extends StatefulWidget {
  const ChatPreviewList({super.key});
  @override
  State<ChatPreviewList> createState() => _ChatPreviewListState();
}

class _ChatPreviewListState extends State<ChatPreviewList> {
  _ChatPreviewListState();

  @override
  void initState() {
    super.initState();
    fillData();
  }

  List<Preview> users = [];
  void fillData() async {
    String myID = UserData.currentLoggedInUser!.uid;
    users = <Preview>[];
    QuerySnapshot chatroomsSnapshot = await FirebaseFirestore.instance
        .collection("chats")
        .orderBy("lastmessagetime", descending: true)
        .get();

    for (QueryDocumentSnapshot chatroomDoc in chatroomsSnapshot.docs) {
      var ids = chatroomDoc.id.split('-');
      if (ids[0] == myID) {
        users.add(Preview(
            user: UserData(uid: ids[1], dontSet: true),
            lastMessage: (chatroomDoc.data()
                as Map<String, dynamic>)['lastmessagecontent'],
            time: (chatroomDoc.data()
                as Map<String, dynamic>)['lastmessagetime']));
      } else if (ids[1] == myID) {
        users.add(Preview(
            user: UserData(uid: ids[0], dontSet: true),
            lastMessage: (chatroomDoc.data()
                as Map<String, dynamic>)['lastmessagecontent'],
            time: (chatroomDoc.data()
                as Map<String, dynamic>)['lastmessagetime']));
      }
    }
    setState(() {
      users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Liste von chat_previews machen
    return Scaffold(
      appBar: AppBar(
        foregroundColor: mainColor,
        title: const Text("Chats", style: TextStyle(color: mainColor)),
        backgroundColor: secondaryColor,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 15),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ChatPreview(prevData: getPreviewByIndex(index));
          }),
    );
  }

  Preview getPreviewByIndex(int index) {
    return users[index];
  }
}
