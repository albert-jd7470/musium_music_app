import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:dio/dio.dart';
import '../api/api_endpoints.dart';
import '../../features/search_screen/data/models/song_model.dart';

import 'history_provider.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final Dio _dio = Dio();
  
  HistoryProvider? historyProvider;
  
  List<SongModel> _queue = [];
  int _currentIndex = -1;

  AudioPlayer get player => _player;
  SongModel? get currentSong => _currentIndex >= 0 && _currentIndex < _queue.length ? _queue[_currentIndex] : null;
  List<SongModel> get queue => _queue;
  int get currentIndex => _currentIndex;
  bool get hasNext => _currentIndex < _queue.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  AudioProvider() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Automatically play next song when current finishes
        if (_player.loopMode == LoopMode.one) {
          // just_audio handles LoopMode.one automatically, but if we manually handle queue:
          // Actually, just_audio seeks to 0 on complete if LoopMode.one is set.
        } else if (hasNext) {
          playNext();
        } else if (_player.loopMode == LoopMode.all && _queue.isNotEmpty) {
          _currentIndex = 0;
          _playCurrentIndex();
        }
      }
      notifyListeners();
    });
  }

  /// Helper to fetch stream URL if the song doesn't have it yet
  Future<SongModel> _ensureDownloadUrl(SongModel song) async {
    if (song.highestQualityDownloadUrl.isNotEmpty) {
      return song;
    }
    if (song.url.isEmpty) return song;

    try {
      final url = '${ApiEndpoints.GetSong}${song.url}';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['status'] == 'SUCCESS' && responseData['data'] != null) {
          final List<dynamic> results = responseData['data'] is List ? responseData['data'] : [responseData['data']];
          if (results.isNotEmpty) {
            final updatedSong = SongModel.fromJson(results.first);
            // Preserve the original artistsList if the updated song lost the IDs.
            // The song details API may parse artists without IDs (empty string), so check
            // that updated artists actually have valid IDs before accepting the new list.
            final updatedHasValidIds = updatedSong.primaryArtistsList.any((a) => a['id'] != null && a['id']!.isNotEmpty);
            final originalHasValidIds = song.primaryArtistsList.any((a) => a['id'] != null && a['id']!.isNotEmpty);
            if (!updatedHasValidIds && originalHasValidIds) {
              return SongModel(
                id: updatedSong.id,
                name: updatedSong.name,
                primaryArtists: updatedSong.primaryArtists.isNotEmpty ? updatedSong.primaryArtists : song.primaryArtists,
                primaryArtistsList: song.primaryArtistsList,
                albumName: updatedSong.albumName,
                year: updatedSong.year,
                duration: updatedSong.duration,
                language: updatedSong.language,
                imageUrls: updatedSong.imageUrls.isNotEmpty ? updatedSong.imageUrls : song.imageUrls,
                highestQualityDownloadUrl: updatedSong.highestQualityDownloadUrl,
                url: updatedSong.url,
              );
            }
            return updatedSong;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching song details for queue: $e');
    }
    return song;
  }

  Future<void> _playCurrentIndex() async {
    if (_currentIndex < 0 || _currentIndex >= _queue.length) return;
    
    SongModel song = _queue[_currentIndex];
    notifyListeners(); // Update UI to show loading for the next song

    song = await _ensureDownloadUrl(song);
    _queue[_currentIndex] = song; // update queue with full details

    final url = song.highestQualityDownloadUrl;
    if (url.isNotEmpty) {
      try {
        final audioSource = AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: song.id,
            album: song.primaryArtists, // Use artists for album context if needed
            title: song.name,
            artist: song.primaryArtists,
            artUri: Uri.parse(song.bestImageUrl),
          ),
        );
        
        await _player.setAudioSource(audioSource);
        _player.play();
        historyProvider?.addSongToHistory(song);
      } catch (e) {
        debugPrint("Error loading audio: $e");
      }
    }
    notifyListeners();
  }

  /// Replace the entire queue and play immediately starting from a specific index
  Future<void> playQueue(List<SongModel> songs, {int initialIndex = 0}) async {
    _queue = List.from(songs);
    if (initialIndex >= 0 && initialIndex < _queue.length) {
      _currentIndex = initialIndex;
      await _playCurrentIndex();
    }
  }

  /// Play a single song, replacing the queue
  Future<void> playSong(SongModel song) async {
    if (currentSong?.id == song.id) {
      if (!_player.playing) {
        _player.play();
      }
      return;
    }

    _queue = [song];
    _currentIndex = 0;
    await _playCurrentIndex();
  }

  Future<void> stopAndClear() async {
    _queue.clear();
    _currentIndex = -1;
    notifyListeners();
    await _player.stop();
  }

  void addToQueue(SongModel song) {
    _queue.add(song);
    notifyListeners();
  }

  void insertNext(SongModel song) {
    if (_queue.isEmpty) {
      playSong(song);
    } else {
      _queue.insert(_currentIndex + 1, song);
      notifyListeners();
    }
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
    notifyListeners();
  }

  void playNext() {
    if (hasNext) {
      _currentIndex++;
      _playCurrentIndex();
    } else if (_player.loopMode == LoopMode.all && _queue.isNotEmpty) {
      _currentIndex = 0;
      _playCurrentIndex();
    }
  }

  void playPrevious() {
    if (hasPrevious) {
      // If we are more than 3 seconds in, just restart the song instead of going back
      if (_player.position.inSeconds > 3) {
        _player.seek(Duration.zero);
      } else {
        _currentIndex--;
        _playCurrentIndex();
      }
    } else {
      _player.seek(Duration.zero);
    }
  }

  void pause() {
    _player.pause();
  }

  void resume() {
    _player.play();
  }

  void stop() {
    _player.stop();
    _queue = [];
    _currentIndex = -1;
    notifyListeners();
  }

  void toggleRepeat() {
    final currentLoopMode = _player.loopMode;
    if (currentLoopMode == LoopMode.off) {
      _player.setLoopMode(LoopMode.one);
    } else if (currentLoopMode == LoopMode.one) {
      _player.setLoopMode(LoopMode.all);
    } else {
      _player.setLoopMode(LoopMode.off);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
