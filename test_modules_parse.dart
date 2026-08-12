import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://server-steel-eight.vercel.app/modules?language=hindi');
    final data = response.data;
    
    if (data['data'] != null) {
      print("Keys in data: ${data['data'].keys}");
      
      if (data['data']['playlists'] != null) {
        final playlists = data['data']['playlists'] as List;
        print("Found ${playlists.length} playlists");
        if (playlists.isNotEmpty) {
          print("First playlist: ${playlists.first}");
        }
      }
    } else {
      print("No data key found");
    }
  } catch(e) {
    print(e);
  }
}
