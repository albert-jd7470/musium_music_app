class SongModel {
  final String id;
  final String name;
  final String primaryArtists;
  final List<Map<String, String>> primaryArtistsList;
  final String albumName;
  final String year;
  final String duration;
  final String language;
  final List<String> imageUrls;
  final String highestQualityDownloadUrl;
  final String url;

  SongModel({
    required this.id,
    required this.name,
    required this.primaryArtists,
    required this.primaryArtistsList,
    required this.albumName,
    required this.year,
    required this.duration,
    required this.language,
    required this.imageUrls,
    required this.highestQualityDownloadUrl,
    required this.url,
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
        // API uses either 'link' (modules) or 'url' (artist songs endpoint)
        final imageUrl = img['link']?.toString() ?? img['url']?.toString() ?? '';
        if (imageUrl.isNotEmpty) {
          parsedImages.add(imageUrl);
        }
      }
    }

    // Get the highest quality download link (usually 320kbps, which is at the end of the array)
    String downloadUrl = '';
    if (json['downloadUrl'] != null && json['downloadUrl'] is List && json['downloadUrl'].isNotEmpty) {
      var lastItem = json['downloadUrl'].last;
      // API uses either 'link' (modules) or 'url' (artist songs endpoint)
      downloadUrl = lastItem['link']?.toString() ?? lastItem['url']?.toString() ?? '';
    }

    String album = '';
    if (json['album'] != null && json['album']['name'] != null) {
      album = decodeHtml(json['album']['name']);
    }

    String parsedArtists = '';
    if (json['primaryArtists'] is String) {
      parsedArtists = decodeHtml(json['primaryArtists']);
    } else if (json['primaryArtists'] is List) {
      parsedArtists = (json['primaryArtists'] as List)
          .map<String>((a) => a['name']?.toString() ?? '')
          .where((String s) => s.isNotEmpty)
          .join(', ');
      parsedArtists = decodeHtml(parsedArtists);
    }

    // Extract actual artist objects with IDs and images if available
    List<Map<String, String>> artistsList = [];

    // Priority 1: already-serialized primaryArtistsList (from toJson/wishlist/history)
    if (json['primaryArtistsList'] != null && json['primaryArtistsList'] is List) {
      for (var a in json['primaryArtistsList']) {
        if (a is Map) {
          artistsList.add({
            'id': a['id']?.toString() ?? '',
            'name': a['name']?.toString() ?? '',
            'image': a['image']?.toString() ?? '',
          });
        }
      }
    }

    // Priority 2: primaryArtists as a List (most APIs return this with correct IDs)
    if (artistsList.isEmpty && json['primaryArtists'] is List) {
      for (var a in json['primaryArtists']) {
        String id = a['id']?.toString() ?? '';
        String name = decodeHtml(a['name']?.toString() ?? '');
        String image = '';
        if (a['image'] is List && (a['image'] as List).isNotEmpty) {
          var lastImg = (a['image'] as List).last;
          image = lastImg['link']?.toString() ?? lastImg['url']?.toString() ?? '';
        }
        if (name.isNotEmpty) {
          artistsList.add({'id': id, 'name': name, 'image': image});
        }
      }
    }

    // Priority 3: artists.primary map (from the artist detail endpoint)
    if (artistsList.isEmpty && json['artists'] is Map && json['artists']['primary'] is List) {
      for (var a in json['artists']['primary']) {
        String id = a['id']?.toString() ?? '';
        String name = decodeHtml(a['name']?.toString() ?? '');
        String image = '';
        if (a['image'] is List && (a['image'] as List).isNotEmpty) {
          image = (a['image'] as List).last['url']?.toString() ?? '';
        }
        if (name.isNotEmpty) {
          artistsList.add({'id': id, 'name': name, 'image': image});
        }
      }
    }

    // Priority 4: artists as a flat List (modules/albums endpoint includes all artists)
    if (artistsList.isEmpty && json['artists'] is List) {
      for (var a in json['artists']) {
        String id = a['id']?.toString() ?? '';
        String name = decodeHtml(a['name']?.toString() ?? '');
        String image = '';
        if (a['image'] is List && (a['image'] as List).isNotEmpty) {
          var lastImg = (a['image'] as List).last;
          image = lastImg['link']?.toString() ?? lastImg['url']?.toString() ?? '';
        }
        if (name.isNotEmpty) {
          artistsList.add({'id': id, 'name': name, 'image': image});
        }
      }
    }

    // Fallback: use primaryArtistsId string to zip with primaryArtists names
    if (!artistsList.any((a) => a['id'] != null && a['id']!.isNotEmpty)) {
      artistsList.clear();
      if (json['primaryArtistsId'] != null && json['primaryArtistsId'].toString().isNotEmpty) {
        List<String> names = parsedArtists.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        List<String> ids = json['primaryArtistsId'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        int minLength = names.length < ids.length ? names.length : ids.length;
        for (int i = 0; i < minLength; i++) {
          artistsList.add({'id': ids[i], 'name': names[i], 'image': ''});
        }
      } else if (parsedArtists.isNotEmpty) {
        artistsList = parsedArtists.split(',').map((e) => {
          'id': '',
          'name': e.trim(),
          'image': ''
        }).where((e) => e['name']!.isNotEmpty).toList();
      }
    }

    return SongModel(
      id: json['id']?.toString() ?? '',
      name: decodeHtml(json['name']?.toString() ?? ''),
      primaryArtists: parsedArtists,
      primaryArtistsList: artistsList,
      albumName: album,
      year: json['year']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      imageUrls: parsedImages,
      highestQualityDownloadUrl: downloadUrl,
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryArtists': primaryArtists,
      'primaryArtistsList': primaryArtistsList,
      'album': {
        'name': albumName,
      },
      'year': year,
      'duration': duration,
      'language': language,
      'image': imageUrls.map((url) => {'link': url}).toList(),
      'downloadUrl': [{'link': highestQualityDownloadUrl}],
      'url': url,
    };
  }

  // Helper to get best image (last one is usually 500x500)
  String get bestImageUrl {
    if (imageUrls.isEmpty) return '';
    return imageUrls.last;
  }
}
