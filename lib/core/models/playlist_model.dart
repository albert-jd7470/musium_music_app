import '../../features/search_screen/data/models/song_model.dart';

class PlaylistModel {
  final String id;
  final String title;
  final List<SongModel> songs;
  final DateTime createdAt;

  PlaylistModel({
    required this.id,
    required this.title,
    required this.songs,
    required this.createdAt,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawSongs = json['songs'] as List<dynamic>? ?? [];
    return PlaylistModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      songs: rawSongs
          .map((s) => SongModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'songs': songs.map((s) => s.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PlaylistModel copyWith({
    String? id,
    String? title,
    List<SongModel>? songs,
    DateTime? createdAt,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      title: title ?? this.title,
      songs: songs ?? this.songs,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool containsSong(String songId) => songs.any((s) => s.id == songId);
}
