import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../widgets/album_art_display.dart';
import '../widgets/player_controls_card.dart';
import '../widgets/playing_header.dart';
import '../widgets/up_next_indicator.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final song = DummyData.currentSong;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Positioned.fill(
            child: Image.network(
              song.imageUrl,
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
                PlayingHeader(albumName: song.albumName),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AlbumArtDisplay(imageUrl: song.imageUrl),
                        const SizedBox(height: 32),
                        PlayerControlsCard(
                          title: song.title,
                          artist: song.artist,
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
