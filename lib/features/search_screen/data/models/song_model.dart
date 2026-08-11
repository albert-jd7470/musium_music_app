class SongModel {
  final String id;
  final String name;
  final String primaryArtists;
  final String albumName;
  final String year;
  final String duration;
  final String language;
  final List<String> imageUrls;
  final String highestQualityDownloadUrl;

  SongModel({
    required this.id,
    required this.name,
    required this.primaryArtists,
    required this.albumName,
    required this.year,
    required this.duration,
    required this.language,
    required this.imageUrls,
    required this.highestQualityDownloadUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    // Helper to decode HTML entities
    String decodeHtml(String text) {
      return text
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&')
          .replaceAll('&#039;', "'")
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>');
    }

    // Parse images to get all quality links, ordered by quality roughly
    List<String> parsedImages = [];
    if (json['image'] != null && json['image'] is List) {
      for (var img in json['image']) {
        if (img['link'] != null) {
          parsedImages.add(img['link']);
        }
      }
    }

    // Get the highest quality download link (usually 320kbps, which is at the end of the array)
    String downloadUrl = '';
    if (json['downloadUrl'] != null && json['downloadUrl'] is List && json['downloadUrl'].isNotEmpty) {
      var lastItem = json['downloadUrl'].last;
      if (lastItem['link'] != null) {
        downloadUrl = lastItem['link'];
      }
    }

    String album = '';
    if (json['album'] != null && json['album']['name'] != null) {
      album = decodeHtml(json['album']['name']);
    }

    return SongModel(
      id: json['id'] ?? '',
      name: decodeHtml(json['name'] ?? ''),
      primaryArtists: decodeHtml(json['primaryArtists'] ?? ''),
      albumName: album,
      year: json['year'] ?? '',
      duration: json['duration'] ?? '',
      language: json['language'] ?? '',
      imageUrls: parsedImages,
      highestQualityDownloadUrl: downloadUrl,
    );
  }

  // Helper to get best image (last one is usually 500x500)
  String get bestImageUrl {
    if (imageUrls.isEmpty) return '';
    return imageUrls.last;
  }
}
