import 'package:witwire/firebaseParser/post_data.dart';
import 'package:witwire/logik/queryhelper.dart';

class LastDayPosts {
  static Future<PostData> getTopPost() async {
    var a = await QueryHelper.getYesterDayQuery()
        .orderBy('likes', descending: true)
        .limit(1)
        .get();
    return PostData.getPostDataFromSnapshot(a.docs.first);
  }

  static Future<(String hashTag, PostData post)> getTopHashTag() async {
    //TODO:

    return ("", null!);
  }

  static Future<PostData> getBottomPost() async {
    var a = await QueryHelper.getYesterDayQuery()
        .orderBy('likes', descending: false)
        .limit(1)
        .get();
    return PostData.getPostDataFromSnapshot(a.docs.first);
  }
}
