import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../../../../features/search_screen/data/models/song_model.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';
import '../widgets/album_art_display.dart';
import '../widgets/player_controls_card.dart';
import '../widgets/playing_header.dart';
import '../widgets/up_next_indicator.dart';
import '../widgets/artist_info_section.dart';

class PlayingScreen extends StatelessWidget {
  final SongModel? song;
  const PlayingScreen({Key? key, this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        // Use the song from the provider, or fallback to the passed song, or fallback to dummy
        final currentSong = audioProvider.currentSong ?? song;
        
        final String title = currentSong != null ? currentSong.name : DummyData.currentSong.title;
        final String artist = currentSong != null ? currentSong.primaryArtists : DummyData.currentSong.artist;
        final String imageUrl = (currentSong != null && currentSong.bestImageUrl.isNotEmpty) 
            ? currentSong.bestImageUrl 
            : DummyData.currentSong.imageUrl;
        final String albumName = (currentSong != null && currentSong.albumName.isNotEmpty) 
            ? currentSong.albumName 
            : DummyData.currentSong.albumName;

        return Scaffold(
          body: Stack(
            children: [
              // Background Image with Blur
              Positioned.fill(
                child: CustomNetworkImage(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
              // Content
              SafeArea(
                child: Column(
                  children: [
                    PlayingHeader(albumName: albumName, currentSong: currentSong),
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
                              song: currentSong,
                              player: audioProvider.player,
                            ),
                            ArtistInfoSection(
                              artistsList: currentSong?.primaryArtistsList ?? [],
                              fallbackImageUrl: imageUrl,
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
      },
    );
  }
}
