import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/providers/audio_provider.dart';

class LibraryHeader extends StatefulWidget {
  const LibraryHeader({Key? key}) : super(key: key);

  @override
  State<LibraryHeader> createState() => _LibraryHeaderState();
}

class _LibraryHeaderState extends State<LibraryHeader> {
  bool _isLooping = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your Library',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              // Single cycling button: Play → Loop → Play…
              GestureDetector(
                onTap: () {
                  final wishlist = Provider.of<WishlistProvider>(context, listen: false).wishlist;
                  if (wishlist.isEmpty) return;
                  final audio = Provider.of<AudioProvider>(context, listen: false);
                  setState(() => _isLooping = !_isLooping);
                  audio.setLoopMode(_isLooping ? LoopMode.all : LoopMode.off);
                  audio.playQueue(wishlist);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1ED760),
                  ),
                  child: Icon(
                    _isLooping ? Icons.loop : Icons.play_arrow,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
