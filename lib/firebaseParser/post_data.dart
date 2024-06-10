import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:witwire/firebaseParser/user_data.dart';

class PostData {
  late String postID;
  late String uid;
  late String username;
  late int likes;
  late String imagePath;
  late String description;
  late DateTime publishedTime;
  late List<String> hashtags;
  late int currentUserLike;
  late String profilePictureURL;
  PostData(
      {required this.postID,
      required this.uid,
      required this.username,
      required this.likes,
      required this.imagePath,
      required this.description,
      required this.publishedTime,
      required this.hashtags,
      required this.currentUserLike,
      required this.profilePictureURL});
  void setCurrentUserLike(int newstatus) async {
    if (newstatus == currentUserLike) return;

    int diff = newstatus - currentUserLike;
    likes += diff;

    DocumentReference postRef =
        FirebaseFirestore.instance.collection("posts").doc(postID);
    String currUserID = UserData.currentLoggedInUser!.uid;
    if (newstatus == 0) {
      postRef.update({
        'votes.$currUserID': FieldValue.delete(),
      });
    } else {
      bool isLike = newstatus == 1;
      postRef.update({
        'votes.$currUserID': isLike,
      });
    }

    currentUserLike = newstatus;
    postRef.update({
      'likes': FieldValue.increment(diff),
    });
  }

  static PostData getPostDataFromSnapshot(QueryDocumentSnapshot<Object?> snap) {
    Map<String, dynamic> votes = snap["votes"] ?? {};

    String currentUserUID = UserData.currentLoggedInUser!.uid;
    int currentUserLike = votes.containsKey(currentUserUID) &&
            votes[currentUserUID] == true
        ? 1
        : votes.containsKey(currentUserUID) && votes[currentUserUID] == false
            ? -1
            : 0;
    return PostData(
        postID: snap["postid"],
        uid: snap["uid"],
        username: snap["username"],
        likes: snap["likes"],
        imagePath: snap["imageURL"],
        description: snap["description"],
        publishedTime: (snap["date"] as Timestamp).toDate(),
        hashtags: List<String>.from(snap["hashtags"]),
        currentUserLike: currentUserLike,
        profilePictureURL: snap["profilePictureURL"]);
  }

  static Future<PostData> create({required String postID}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('posts').doc(postID).get();
    Map<String, dynamic> asMap = (snap.data() as Map<String, dynamic>);

    String uid = asMap["uid"];
    String username = asMap["username"];
    int likes = asMap["likes"];
    String imagePath = asMap["imageURL"];
    String description = asMap["description"];
    String profilePictureURL = asMap["profilePictureURL"];
    DateTime publishedTime = (asMap["date"] as Timestamp).toDate();
    List<String> hashtags = List<String>.from(asMap["hashtags"]);
    Map<String, dynamic> votes = asMap["votes"] ?? {};

    String currentUserUID = UserData.currentLoggedInUser!.uid;
    int currentUserLike = votes.containsKey(currentUserUID) &&
            votes[currentUserUID] == true
        ? 1
        : votes.containsKey(currentUserUID) && votes[currentUserUID] == false
            ? -1
            : 0;

    return PostData(
        postID: postID,
        uid: uid,
        username: username,
        likes: likes,
        imagePath: imagePath,
        description: description,
        publishedTime: publishedTime,
        hashtags: hashtags,
        currentUserLike: currentUserLike,
        profilePictureURL: profilePictureURL);
  }
}
