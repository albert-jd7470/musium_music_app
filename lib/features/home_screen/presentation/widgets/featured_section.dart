import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musium_music_app/core/presentation/widgets/custom_network_image.dart';
import '../../../../core/models/featured_item_model.dart';
import '../providers/trending_provider.dart';
import '../../../../core/services/playlist_service.dart';
import '../screens/feature_playlist_screen.dart';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({Key? key}) : super(key: key);

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  List<FeaturedItemModel>? _featuredItems;
  bool _isLoading = true;
  String? _lastLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLanguage = Provider.of<TrendingProvider>(context).selectedLanguage;
    if (_lastLanguage != newLanguage) {
      _lastLanguage = newLanguage;
      _loadFeaturedItems(newLanguage);
    }
  }

  Future<void> _loadFeaturedItems(String language) async {
    // Only show loading if it's the very first load or if we want to show spinner on language change
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final items = await PlaylistService.fetchFeaturedPlaylists(language);
      
      if (mounted) {
        setState(() {
          _featuredItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading featured items: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Featured',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 320,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ],
      );
    }

    if (_featuredItems == null || _featuredItems!.isEmpty) {
      return const SizedBox.shrink(); // Don't show the section if no items
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            'Featured',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 24.0, right: 8.0),
            scrollDirection: Axis.horizontal,
            itemCount: _featuredItems!.length,
            itemBuilder: (context, index) {
              final item = _featuredItems![index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => FeaturePlaylistScreen(featuredItem: item),
                    ),
                  );
                },
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0),
                          ),
                          child: item.imageUrl.isNotEmpty 
                            ? CustomNetworkImage(
                                item.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                color: Colors.grey[800],
                                child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE0E0E0),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
