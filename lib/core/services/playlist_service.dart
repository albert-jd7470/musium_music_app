import 'package:dio/dio.dart';
import '../models/featured_item_model.dart';
import '../../features/search_screen/data/models/song_model.dart';

class PlaylistService {
  static final Dio _dio = Dio();

  /// 🔹 Fetch songs from a JioSaavn playlist
  static Future<List<SongModel>> fetchPlaylistSongs(String playlistId) async {
    try {
      final response = await _dio.get(
        'https://server-steel-eight.vercel.app/playlists',
        queryParameters: {
          'id': playlistId,
        },
      );
      if (response.statusCode == 200) {
        // Dio automatically decodes JSON
        final data = response.data;
        
        // Extract the songs list from the response
        final songsData = data['data']?['songs'] ?? data['data'] ?? [];
        return (songsData as List).map<SongModel>((e) {
          return SongModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print('💥 Error fetching playlist songs: $e');
      return [];
    }
  }

  /// 🔹 Fetch Featured Playlists based on Language
  static Future<List<FeaturedItemModel>> fetchFeaturedPlaylists(String language) async {
    try {
      final response = await _dio.get(
        'https://server-steel-eight.vercel.app/modules',
        queryParameters: {
          'language': language,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null && data['data']['playlists'] != null) {
          final playlists = data['data']['playlists'] as List;
          return playlists.map((e) => FeaturedItemModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('💥 Error fetching featured playlists: $e');
      return [];
    }
  }

  /// 🔹 Fetch songs from a JioSaavn Album
  static Future<List<SongModel>> fetchAlbumSongs(String albumUrl) async {
    try {
      final response = await _dio.get(
        'https://server-steel-eight.vercel.app/albums',
        queryParameters: {
          'link': albumUrl,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final songsData = data['data']?['songs'] ?? [];
        return (songsData as List).map<SongModel>((e) {
          return SongModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print('💥 Error fetching album songs: $e');
      return [];
    }
  }

  /// 🔹 Auto-detects whether the URL is an Album or Playlist and fetches accordingly
  static Future<List<SongModel>> fetchSongsAuto(String link) async {
    if (link.contains('/album/')) {
      print("🎶 Detected Album Link");
      return await fetchAlbumSongs(link);
    } else {
      print("🎶 Detected Playlist Link");
      return await fetchPlaylistSongs(link);
    }
  }
}
