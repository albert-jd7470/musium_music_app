import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseurl => dotenv.env['BASE_URL'] ?? 'https://server-steel-eight.vercel.app';

  // ✅ Trending, Albums, Songs
  static String get GetTrendinglanguages => '$baseurl/modules?language=';
  static String get GetAlbumSongs => '$baseurl/albums?link=';
  static String get SearchEndpoint => '$baseurl/search/songs?query=';
  static String get GetNewRelease => dotenv.env['NEW_RELEASE_URL'] ?? 'https://www.jiosaavn.com/api.php?';
  static String get Getlyrics => '$baseurl/lyrics?id=';
  static String get GetSong => "$baseurl/songs?link=";

  static String get playlistbase => '$baseurl/playlists';

  static String get redirecturl => dotenv.env['REDIRECT_URL'] ?? 'app://space/auth';
  static String get clientid => dotenv.env['CLIENT_ID'] ?? '08de4eaf71904d1b95254fab3015d711';
  static String get clientSecret => dotenv.env['CLIENT_SECRET'] ?? '622b4fbad33947c59b95a6ae607de11d';
  static String get ytdislike => dotenv.env['YT_DISLIKE_URL'] ?? 'https://returnyoutubedislikeapi.com/votes?videoId=';
  static String get Suggestionurl => dotenv.env['SUGGESTION_URL'] ?? "https://getit-three.vercel.app/";

  final String jiosaavnSearchSong = '&n=10&__call=search.getResults';
  final String GetTopSeraches = 'content.getTopSearches';
}
