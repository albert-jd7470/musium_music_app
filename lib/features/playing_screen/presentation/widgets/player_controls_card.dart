import 'package:flutter/material.dart';

class PlayerControlsCard extends StatelessWidget {
  final String title;
  final String artist;

  const PlayerControlsCard({
    Key? key,
    required this.title,
    required this.artist,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Progress Bar
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width * 0.4, // Example progress
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.4 - 8,
                top: -4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1:42',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
              Text(
                '3:54',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ],
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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFD3C8C4), // Light beige play button
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.black, size: 40),
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
}
