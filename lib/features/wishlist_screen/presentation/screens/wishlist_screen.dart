import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/main_header.dart';
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
                                child: Image.network(
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
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Color(0xFF1ED760),
                                  size: 24,
                                ),
                                onPressed: () {
                                  wishlistProvider.toggleWishlist(song);
                                },
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
