import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArtistInfoSection extends StatelessWidget {
  final List<Map<String, String>> artistsList;
  final String fallbackImageUrl;

  const ArtistInfoSection({
    Key? key,
    required this.artistsList,
    required this.fallbackImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (artistsList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Artists',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 136,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: artistsList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final artist = artistsList[index];
                return GestureDetector(
                  onTap: () {
                    print('🎵 ARTIST TAPPED: name=${artist['name']}, id=${artist['id']}, image=${artist['image']}');
                    print('🎵 Full artistsList: $artistsList');
                    if (artist['id'] != null && artist['id']!.isNotEmpty) {
                      print('🎵 Navigating to /artist/${artist['id']}');
                      context.push('/artist/${artist['id']}', extra: artist['name']);
                    } else {
                      print('🎵 Navigation SKIPPED: artist id is empty!');
                    }
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: artist['image'] != null && artist['image']!.isNotEmpty
                            ? CachedNetworkImageProvider(artist['image']!) as ImageProvider
                            : (fallbackImageUrl.isNotEmpty ? CachedNetworkImageProvider(fallbackImageUrl) : null),
                        child: (artist['image'] == null || artist['image']!.isEmpty) && fallbackImageUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.white54, size: 36)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 80,
                        child: Text(
                          artist['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
