import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:witwire/firebaseParser/user_data.dart';

class PostData {
  late String postID;
  late bool canBeLiked;
  late String uid;
  late String username;
  late int likes;
  late String imagePath;
  late String description;
  late DateTime publishedTime;
  late List<String> hashtags;
  late int currentUserLike;

  PostData._({
    required this.postID,
    required this.canBeLiked,
    required this.uid,
    required this.username,
    required this.likes,
    required this.imagePath,
    required this.description,
    required this.publishedTime,
    required this.hashtags,
    required this.currentUserLike,
  });

  static Future<PostData> create(
      {required String postID, required bool canBeLiked}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('posts').doc(postID).get();
    Map<String, dynamic> asMap = (snap.data() as Map<String, dynamic>);

    String uid = asMap["uid"];
    String username = asMap["username"];
    int likes = asMap["likes"];
    String imagePath = asMap["imageURL"];
    String description = asMap["description"];
    DateTime publishedTime = (asMap["date"] as Timestamp).toDate();
    List<String> hashtags = List<String>.from(asMap["hashtags"]);
    Map<String, dynamic> votes = asMap["votes"] ?? {};

    String currentUserUID = UserData.currentLoggedInUser!.uid;
    int currentUserLike = votes.containsKey(currentUserUID) &&
            votes[currentUserUID] == true
        ? 1
        : votes.containsKey(currentUserUID) && votes[currentUserUID] == false
            ? 2
            : 0;

    return PostData._(
      postID: postID,
      canBeLiked: canBeLiked,
      uid: uid,
      username: username,
      likes: likes,
      imagePath: imagePath,
      description: description,
      publishedTime: publishedTime,
      hashtags: hashtags,
      currentUserLike: currentUserLike,
    );
  }
}
