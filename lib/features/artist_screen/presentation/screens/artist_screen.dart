import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../features/search_screen/data/models/song_model.dart';
import '../../../../core/presentation/widgets/mini_player.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';

class ArtistScreen extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ArtistScreen({
    Key? key,
    required this.artistId,
    required this.artistName,
  }) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  List<SongModel> topTracks = [];
  bool isLoading = true;
  String? errorMessage;
  // A reliable dark concert/music fallback image
  String artistImage = 'https://images.unsplash.com/photo-1501386761578-eaa54b492da7?w=1170&q=80';
  
  // 0: Play, 1: Play All, 2: Loop All
  int _playModeIndex = 0;

  String get _playModeText {
    switch (_playModeIndex) {
      case 0: return 'Play';
      case 1: return 'Play All';
      case 2: return 'Loop All';
      default: return 'Play';
    }
  }

  IconData get _playModeIcon {
    switch (_playModeIndex) {
      case 0: return Icons.play_arrow;
      case 1: return Icons.playlist_play;
      case 2: return Icons.loop;
      default: return Icons.play_arrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchArtistSongs();
  }

  Future<void> _fetchArtistSongs() async {
    try {
      final List<SongModel> allSongs = [];
      int page = 1;
      int total = 0;
      const int pageSize = 10;

      // Fetch first page to know total count
      final firstUrl = 'https://getit-three.vercel.app/api/artists/${widget.artistId}/songs?page=$page&limit=$pageSize';
      print('🎤 Fetching artist songs: $firstUrl');
      final firstResponse = await http.get(Uri.parse(firstUrl));
      print('🎤 Response status: ${firstResponse.statusCode}');

      if (firstResponse.statusCode != 200) {
        setState(() {
          errorMessage = 'Failed to load tracks (${firstResponse.statusCode}).';
          isLoading = false;
        });
        return;
      }

      final firstData = json.decode(firstResponse.body);
      if (firstData['success'] != true || firstData['data'] == null || firstData['data']['songs'] == null) {
        setState(() {
          errorMessage = 'No tracks found.';
          isLoading = false;
        });
        return;
      }

      total = firstData['data']['total'] ?? 0;
      final List<dynamic> firstSongs = firstData['data']['songs'];
      allSongs.addAll(firstSongs.map((s) => SongModel.fromJson(s)));
      print('🎤 Page 1: ${firstSongs.length} songs, total: $total');

      // Show first page immediately
      if (allSongs.isNotEmpty) {
        setState(() {
          topTracks = List.from(allSongs);
          isLoading = false;
          if (allSongs.first.bestImageUrl.isNotEmpty) {
            artistImage = allSongs.first.bestImageUrl;
          }
        });
      }

      // Fetch remaining pages in background
      final int totalPages = (total / pageSize).ceil();
      for (page = 2; page <= totalPages; page++) {
        final url = 'https://getit-three.vercel.app/api/artists/${widget.artistId}/songs?page=$page&limit=$pageSize';
        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['success'] == true && data['data']?['songs'] != null) {
              final List<dynamic> songs = data['data']['songs'];
              allSongs.addAll(songs.map((s) => SongModel.fromJson(s)));
              print('🎤 Page $page: ${songs.length} songs (total loaded: ${allSongs.length})');
              if (mounted) {
                setState(() {
                  topTracks = List.from(allSongs);
                });
              }
            }
          }
        } catch (e) {
          print('🎤 Error fetching page $page: $e');
        }
        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 100));
      }
      print('🎤 All pages loaded: ${allSongs.length} tracks total');
    } catch (e) {
      print('🎤 Exception: $e');
      setState(() {
        if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
          errorMessage = 'No internet connection.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        isLoading = false;
      });
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
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
            title: const Text('Artist Profile', style: TextStyle(fontSize: 16, color: Colors.white)),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CustomNetworkImage(
                    artistImage,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay to make text readable
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF121212).withOpacity(0.8),
                          const Color(0xFF121212),
                        ],
                        stops: const [0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artist Name & Monthly Listeners
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.artistName,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.grey, size: 20),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (topTracks.isEmpty) return;
                            final audioProvider = Provider.of<AudioProvider>(context, listen: false);

                            if (_playModeIndex == 0) {
                              // Play a single song (the first one) and stop
                              audioProvider.setLoopMode(LoopMode.off);
                              audioProvider.playSong(topTracks.first);
                            } else if (_playModeIndex == 1) {
                              // Play the entire queue and stop at the end
                              audioProvider.setLoopMode(LoopMode.off);
                              audioProvider.playQueue(topTracks);
                            } else if (_playModeIndex == 2) {
                              // Play the entire queue and loop endlessly
                              audioProvider.setLoopMode(LoopMode.all);
                              audioProvider.playQueue(topTracks);
                            }

                            // Cycle to the next mode for the next tap
                            setState(() {
                              _playModeIndex = (_playModeIndex + 1) % 3;
                            });
                          },
                          icon: Icon(_playModeIcon, color: Colors.black),
                          label: Text(_playModeText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD3C8C4),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Songs Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Songs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Top Tracks List
                  if (isLoading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                    ))
                  else if (errorMessage != null)
                    Center(child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                    ))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: topTracks.length,
                      itemBuilder: (context, index) {
                        final song = topTracks[index];
                        return _buildTrackRow(context, song, index + 1);
                      },
                    ),

                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackRow(BuildContext context, SongModel song, int index) {
    // Generate dummy listeners count for UI mockup fidelity
    final randomListeners = (15000000 - (index * 2000000)).toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    
    // Format duration
    String formatDuration(String secondsStr) {
      int? seconds = int.tryParse(secondsStr);
      if (seconds == null) return "0:00";
      int min = seconds ~/ 60;
      int sec = seconds % 60;
      return "$min:${sec.toString().padLeft(2, '0')}";
    }

    return GestureDetector(
      onTap: () {
        // Pass all tracks as a queue, starting from the tapped song's index (0-based)
        Provider.of<AudioProvider>(context, listen: false).playQueue(topTracks, initialIndex: index - 1);
        context.push('/playing');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CustomNetworkImage(
                song.bestImageUrl.isNotEmpty ? song.bestImageUrl : 'https://via.placeholder.com/50',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    randomListeners,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'fav') {
                  Provider.of<WishlistProvider>(context, listen: false).toggleWishlist(song);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${song.name} added to favorites!'),
                      backgroundColor: const Color(0xFF1ED760),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (value == 'queue') {
                  Provider.of<AudioProvider>(context, listen: false).insertNext(song);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${song.name} will play next!'),
                      backgroundColor: const Color(0xFF1ED760),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.6), size: 20),
              color: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'fav',
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text('Add to Favorites', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'queue',
                  child: Row(
                    children: [
                      Icon(Icons.queue_music, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text('Play Next', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: CustomNetworkImage(
              imageUrl,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
