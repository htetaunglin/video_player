import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// From ext_video_player
class YoutubeUtils {
  static bool isYoutubeLink(String url) {
    final List<RegExp> regexps = [
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
    ];
    if (url.isEmpty) {
      return false;
    }

    for (RegExp exp in regexps) {
      final Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return true;
      }
    }
    return false;
  }

  static String? getYoutubeIdFromUrl(String url,
      [bool trimWhitespaces = true]) {
    final List<RegExp> regexps = [
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
    ];

    if (url.isEmpty) {
      return null;
    }

    if (trimWhitespaces) {
      url = url.trim();
    }

    for (RegExp exp in regexps) {
      final Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  static Future<String?> generateDownloadVideoUrl(String url,
      [VideoQuality? quality]) async {
    var videoId = getYoutubeIdFromUrl(url);
    if (videoId == null) {
      return null;
    }
    VideoQuality quali = quality ?? VideoQuality.high720;
    var yt = YoutubeExplode();
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    Uri? videoUri;
    for (var m in manifest.muxed) {
      if (quali == m.videoQuality) {
        videoUri = m.url;
      }
    }
    if (videoUri == null) {
      return manifest.muxed.first.url.toString();
    } else {
      return videoUri.toString();
    }
  }
}
