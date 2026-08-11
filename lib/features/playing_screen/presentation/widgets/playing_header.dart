import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayingHeader extends StatelessWidget {
  final String albumName;

  const PlayingHeader({Key? key, required this.albumName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'PLAYING FROM ALBUM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  albumName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
