import 'package:flutter/material.dart';
import '../../../../features/home_screen/data/dummy_data.dart';

class LibraryListItem extends StatelessWidget {
  final LibraryItem item;

  const LibraryListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24), // Dark rounded card
        borderRadius: BorderRadius.circular(40.0), // Pill shape
      ),
      child: Row(
        children: [
          // Album Art
          ClipRRect(
            borderRadius: BorderRadius.circular(28.0), // Rounded inner image
            child: Image.network(
              item.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.artist} • ${item.genre}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Action Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.isDownloaded ? Icons.check : Icons.download_outlined,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 16.0),
              const Icon(
                Icons.favorite,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        ],
      ),
    );
  }
}
