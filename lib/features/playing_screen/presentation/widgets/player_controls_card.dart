import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../features/search_screen/data/models/song_model.dart';

class PlayerControlsCard extends StatelessWidget {
  final String title;
  final String artist;
  final SongModel? song;
  final AudioPlayer? player;

  const PlayerControlsCard({
    Key? key,
    required this.title,
    required this.artist,
    this.song,
    this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24), // Dark rounded card
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artist,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (song != null)
                Consumer<WishlistProvider>(
                  builder: (context, wishlistProvider, child) {
                    final isWishlisted = wishlistProvider.isWishlisted(song!.id);
                    return IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? const Color(0xFF1ED760) : Colors.white70,
                      ),
                      onPressed: () {
                        wishlistProvider.toggleWishlist(song!);
                      },
                    );
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white70),
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Dynamic Progress Bar
          StreamBuilder<Duration?>(
            stream: player?.durationStream,
            builder: (context, durationSnapshot) {
              final duration = durationSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: player?.positionStream,
                builder: (context, positionSnapshot) {
                  var position = positionSnapshot.data ?? Duration.zero;
                  if (position > duration) position = duration;
                  
                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4.0,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.1),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                          trackShape: const RectangularSliderTrackShape(),
                        ),
                        child: Slider(
                          value: (position.inMilliseconds.toDouble()).clamp(0.0, duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0),
                          max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                          onChanged: (value) {
                            player?.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          // Main Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                onPressed: () {
                  Provider.of<AudioProvider>(context, listen: false).playPrevious();
                },
              ),
              StreamBuilder<PlayerState>(
                stream: player?.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;

                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD3C8C4),
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  } else if (playing != true) {
                    return GestureDetector(
                      onTap: () => player?.play(),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD3C8C4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.black, size: 40),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => player?.pause(),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD3C8C4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.pause, color: Colors.black, size: 40),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                onPressed: () {
                  Provider.of<AudioProvider>(context, listen: false).playNext();
                },
              ),
              StreamBuilder<LoopMode>(
                stream: player?.loopModeStream,
                builder: (context, snapshot) {
                  final loopMode = snapshot.data ?? LoopMode.off;
                  return IconButton(
                    icon: Icon(
                      loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                      color: loopMode == LoopMode.off ? Colors.white : const Color(0xFF1ED760),
                    ),
                    onPressed: () {
                      if (player != null) {
                        if (loopMode == LoopMode.off) {
                          player!.setLoopMode(LoopMode.one);
                        } else {
                          player!.setLoopMode(LoopMode.off);
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Volume and extra controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lyrics_outlined, color: Colors.white54, size: 20),
              const SizedBox(width: 16),
              const Icon(Icons.volume_down, color: Colors.white54, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: const VolumeSliderWidget(),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.volume_up, color: Colors.white54, size: 16),
              const SizedBox(width: 16),
              const Icon(Icons.queue_music, color: Colors.white54, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "0:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${duration.inMinutes.toString()}:$twoDigitSeconds";
    }
  }
}

class VolumeSliderWidget extends StatefulWidget {
  const VolumeSliderWidget({Key? key}) : super(key: key);

  @override
  State<VolumeSliderWidget> createState() => _VolumeSliderWidgetState();
}

class _VolumeSliderWidgetState extends State<VolumeSliderWidget> {
  double _currentVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _initVolume();
  }

  Future<void> _initVolume() async {
    // Hide UI Volume overlay to match native feel natively (Optional)
    VolumeController.instance.showSystemUI = false; 
    
    // Get initial volume
    _currentVolume = await VolumeController.instance.getVolume();
    if (mounted) setState(() {});

    // Listen to volume changes (hardware buttons)
    VolumeController.instance.addListener((volume) {
      if (mounted) {
        setState(() {
          _currentVolume = volume;
        });
      }
    });
  }

  @override
  void dispose() {
    VolumeController.instance.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2.0,
        activeTrackColor: Colors.white54,
        inactiveTrackColor: Colors.white.withOpacity(0.1),
        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Slider(
        value: _currentVolume,
        min: 0.0,
        max: 1.0,
        onChanged: (val) {
          setState(() {
            _currentVolume = val;
          });
          VolumeController.instance.setVolume(val);
        },
      ),
    );
  }
}
