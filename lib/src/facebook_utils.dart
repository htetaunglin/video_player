import 'package:direct_link/direct_link.dart';

class FacebookUtils {
  static bool isFacebookUrl(String url) {
    return url.startsWith("https://www.facebook.com") ||
        url.startsWith("https://fb.watch");
  }

  static Future<String?> generateDownloadVideoUrl(String url) async {
    var check = await DirectLink.check(url); // add your url
    if (check == null || check.isEmpty) {
      return null;
    } else {
      if (check.map((e) => e.quality).contains("hd")) {
        return check.singleWhere((element) => element.quality == "hd").link;
      } else {
        return check.first.link;
      }
    }
  }
}
