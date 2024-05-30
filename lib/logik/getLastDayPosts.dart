import 'package:witwire/firebaseParser/postData.dart';

//TODO: Mit korrekten Datenbank-Abfragen verbinden.
class LastDayPosts {
  static Future<PostData> getTopPost() async {
    return await PostData.create(
        postID: "jKpOcoiqzsVIy6lWdF63", canBeLiked: false);
  }
}
