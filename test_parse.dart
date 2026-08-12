import 'dart:convert';
import 'package:dio/dio.dart';
import 'lib/core/models/album_element.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get(
      'https://server-steel-eight.vercel.app/playlists',
      queryParameters: {
        'id': '1167751266',
      },
    );
    
    final data = response.data;
    final songsData = data['data']?['songs'] ?? data['data'] ?? [];
    
    final songsList = (songsData as List).map<AlbumElement>((e) {
      return AlbumElement(
        id: e['id']?.toString() ?? '',
        name: e['name'] ?? e['title'] ?? '',
        url: e['url'] ?? '',
        language: e['language'] ?? '',
        primaryArtists: _parseArtists(e['primaryArtists']),
        image: (e['image'] as List? ?? [])
            .map((img) => ImageElement(link: img['link'] ?? ''))
            .toList(),
      );
    }).toList();
    
    print("Parsed successfully: ${songsList.length} songs");
  } catch (e) {
    print("Exception: $e");
  }
}

List<Artist> _parseArtists(dynamic artistsData) {
  if (artistsData is List) {
    return artistsData
        .map((a) => Artist(
              id: a['id']?.toString() ?? '',
              name: a['name'] ?? '',
            ))
        .toList();
  } else if (artistsData is String) {
    return artistsData
        .split(',')
        .map((name) => Artist(id: '', name: name.trim()))
        .toList();
  }
  return [];
}
