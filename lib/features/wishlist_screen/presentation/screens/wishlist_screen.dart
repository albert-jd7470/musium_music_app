import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/main_header.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/providers/audio_provider.dart';
import '../widgets/filter_chips_section.dart';
import '../widgets/library_header.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: 'Wishlist',
            ),
            const LibraryHeader(),
            const SizedBox(height: 8),
            const FilterChipsSection(
              filters: ['All', 'Songs'], // Simplified filters
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, child) {
                  final wishlist = wishlistProvider.wishlist;

                  if (wishlist.isEmpty) {
                    return Center(
                      child: Text(
                        'Your wishlist is empty.',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      final song = wishlist[index];
                      return GestureDetector(
                        onTap: () {
                          Provider.of<AudioProvider>(context, listen: false).playQueue(
                            wishlist,
                            initialIndex: index,
                          );
                          context.push('/playing');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E24),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CustomNetworkImage(
                                  song.bestImageUrl.isNotEmpty ? song.bestImageUrl : 'https://via.placeholder.com/56',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      song.name,
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
                                      song.primaryArtists,
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
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'remove') {
                                    wishlistProvider.toggleWishlist(song);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('"${song.name}" removed from wishlist.'),
                                        backgroundColor: const Color(0xFF2C2C2C),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  } else if (value == 'queue') {
                                    Provider.of<AudioProvider>(context, listen: false)
                                        .insertNext(song);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('"${song.name}" will play next!'),
                                        backgroundColor: const Color(0xFF1ED760),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 22,
                                ),
                                color: const Color(0xFF2C2C2C),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'remove',
                                    child: Row(children: [
                                      Icon(Icons.favorite_border,
                                          color: Colors.redAccent, size: 20),
                                      SizedBox(width: 12),
                                      Text('Remove from Wishlist',
                                          style: TextStyle(color: Colors.redAccent)),
                                    ]),
                                  ),
                                  const PopupMenuItem(
                                    value: 'queue',
                                    child: Row(children: [
                                      Icon(Icons.queue_music,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 12),
                                      Text('Play in Queue',
                                          style: TextStyle(color: Colors.white)),
                                    ]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
