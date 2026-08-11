import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../../../../features/search_screen/data/models/song_model.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/album_art_display.dart';
import '../widgets/player_controls_card.dart';
import '../widgets/playing_header.dart';
import '../widgets/up_next_indicator.dart';

class PlayingScreen extends StatefulWidget {
  final SongModel? song;
  const PlayingScreen({Key? key, this.song}) : super(key: key);

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final url = widget.song?.highestQualityDownloadUrl;
    if (url != null && url.isNotEmpty) {
      try {
        await _player.setUrl(url);
        _player.play();
      } catch (e) {
        debugPrint("Error loading audio: $e");
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If a live song is passed, use its data; otherwise fallback to dummy data
    final String title = widget.song != null ? widget.song!.name : DummyData.currentSong.title;
    final String artist = widget.song != null ? widget.song!.primaryArtists : DummyData.currentSong.artist;
    final String imageUrl = (widget.song != null && widget.song!.bestImageUrl.isNotEmpty) 
        ? widget.song!.bestImageUrl 
        : DummyData.currentSong.imageUrl;
    final String albumName = (widget.song != null && widget.song!.albumName.isNotEmpty) 
        ? widget.song!.albumName 
        : DummyData.currentSong.albumName;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: Container(
                color: Colors.black.withOpacity(0.4), // Darken the blurred image
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                PlayingHeader(albumName: albumName),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AlbumArtDisplay(imageUrl: imageUrl),
                        const SizedBox(height: 32),
                        PlayerControlsCard(
                          title: title,
                          artist: artist,
                          player: _player,
                        ),
                        const UpNextIndicator(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
