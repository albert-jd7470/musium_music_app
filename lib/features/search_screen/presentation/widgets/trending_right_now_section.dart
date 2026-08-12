import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../features/home_screen/presentation/providers/trending_provider.dart';

class TrendingRightNowSection extends StatelessWidget {
  const TrendingRightNowSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TrendingProvider>(
      builder: (context, provider, _) {
        // Only show when we have real data
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1ED760),
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (provider.trendingSongs.isEmpty) return const SizedBox.shrink();

        final songs = provider.trendingSongs.take(2).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 12.0),
              child: Text(
                'Trending  Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<AudioProvider>(context, listen: false)
                          .playQueue(songs, initialIndex: index);
                      context.push('/playing');
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: CustomNetworkImage(
                            song.bestImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              const SizedBox(height: 4.0),
                              Text(
                                song.primaryArtists,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
          ],
        );
      },
    );
  }
}
