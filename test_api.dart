import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get(
      'https://server-steel-eight.vercel.app/playlists',
      queryParameters: {
        'id': '1167751266',
      },
    );
    print("Response status: ${response.statusCode}");
    
    final data = response.data;
    final songsData = data['data']?['songs'] ?? data['data'] ?? [];
    
    print("Songs Data type: ${songsData.runtimeType}");
    if (songsData is List) {
      print("First song: ${songsData.first}");
    } else {
      print("songsData is not a List: $songsData");
    }
  } catch (e) {
    print("Exception: $e");
  }
}
