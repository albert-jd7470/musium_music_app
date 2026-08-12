import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../features/search_screen/data/models/song_model.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/presentation/widgets/add_to_playlist_sheet.dart';

class PlayingHeader extends StatelessWidget {
  final String albumName;
  final SongModel? currentSong;

  const PlayingHeader({Key? key, required this.albumName, this.currentSong}) : super(key: key);

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
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (currentSong == null) return;
                
                if (value == 'wishlist') {
                  Provider.of<WishlistProvider>(context, listen: false).toggleWishlist(currentSong!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${currentSong!.name} added to wishlist!'),
                      backgroundColor: const Color(0xFF1ED760),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (value == 'playlist') {
                  showAddToPlaylistSheet(context, currentSong!);
                }
              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'wishlist',
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text('Add to Wishlist', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'playlist',
                  child: Row(
                    children: [
                      Icon(Icons.playlist_add, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text('Add to Playlist', style: TextStyle(color: Colors.white)),
                    ],
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
