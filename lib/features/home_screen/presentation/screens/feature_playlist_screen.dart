import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/playlist_service.dart';
import '../../../../core/models/featured_item_model.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';
import '../../../../core/presentation/widgets/mini_player.dart';
import '../../../../core/presentation/widgets/add_to_playlist_sheet.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../features/search_screen/data/models/song_model.dart';

class FeaturePlaylistScreen extends StatefulWidget {
  final FeaturedItemModel featuredItem;

  const FeaturePlaylistScreen({Key? key, required this.featuredItem}) : super(key: key);

  @override
  State<FeaturePlaylistScreen> createState() => _FeaturePlaylistScreenState();
}

class _FeaturePlaylistScreenState extends State<FeaturePlaylistScreen> {
  List<SongModel>? _songs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      final songs = await PlaylistService.fetchSongsAuto(widget.featuredItem.targetUrl);
      if (mounted) {
        setState(() {
          _songs = songs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
        child: SafeArea(child: MiniPlayer()),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.featuredItem.imageUrl.isNotEmpty
                      ? CustomNetworkImage(
                          widget.featuredItem.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: const Color(0xFF1E1E24),
                          child: const Icon(Icons.music_note, color: Colors.white12, size: 80),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF121212).withOpacity(0.7),
                          const Color(0xFF121212),
                        ],
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.featuredItem.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.featuredItem.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  if (_songs != null && _songs!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<AudioProvider>(context, listen: false).playQueue(_songs!, initialIndex: 0);
                          context.push('/playing');
                        },
                        icon: const Icon(Icons.play_arrow, color: Colors.black),
                        label: const Text(
                          'Play All',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1ED760),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF1ED760)),
              ),
            )
          else if (_songs == null || _songs!.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No songs found.', style: TextStyle(color: Colors.white)),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final song = _songs![index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: song.bestImageUrl.isNotEmpty
                          ? CustomNetworkImage(
                              song.bestImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, color: Colors.white),
                            ),
                    ),
                    title: Text(
                      song.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.primaryArtists,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, _) {
                        final isWishlisted = wishlistProvider.isWishlisted(song.id);
                        return PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'queue') {
                              Provider.of<AudioProvider>(context, listen: false).addToQueue(song);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added "${song.name}" to queue'),
                                  backgroundColor: const Color(0xFF2C2C2C),
                                ),
                              );
                            } else if (value == 'wishlist') {
                              await wishlistProvider.toggleWishlist(song);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isWishlisted ? 'Removed from Wishlist' : 'Added to Wishlist'),
                                  backgroundColor: const Color(0xFF2C2C2C),
                                ),
                              );
                            } else if (value == 'playlist') {
                              showAddToPlaylistSheet(context, song);
                            }
                          },
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          color: const Color(0xFF2C2C2C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'queue',
                              child: Row(
                                children: [
                                  Icon(Icons.queue_music, color: Colors.white, size: 18),
                                  SizedBox(width: 10),
                                  Text('Add to Queue', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'wishlist',
                              child: Row(
                                children: [
                                  Icon(
                                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                                    color: isWishlisted ? Colors.redAccent : Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isWishlisted ? 'Remove from Wishlist' : 'Add to Wishlist',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'playlist',
                              child: Row(
                                children: [
                                  Icon(Icons.playlist_add, color: Colors.white, size: 18),
                                  SizedBox(width: 10),
                                  Text('Add to Playlist', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    onTap: () {
                      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                      audioProvider.playQueue(_songs!, initialIndex: index);
                      context.push('/playing');
                    },
                  );
                },
                childCount: _songs!.length,
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}
