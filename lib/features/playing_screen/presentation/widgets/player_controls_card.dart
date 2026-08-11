import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControlsCard extends StatelessWidget {
  final String title;
  final String artist;
  final AudioPlayer? player;

  const PlayerControlsCard({
    Key? key,
    required this.title,
    required this.artist,
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
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white70),
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
                onPressed: () {},
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
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.repeat, color: Colors.white),
                onPressed: () {},
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
                child: Stack(
                  children: [
                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
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
