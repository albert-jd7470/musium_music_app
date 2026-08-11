import 'package:flutter/material.dart';
import 'package:musium_music_app/features/search_screen/data/models/song_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/audio_provider.dart';
import '../providers/trending_provider.dart';

class TrendingNowSection extends StatelessWidget {
  const TrendingNowSection({Key? key}) : super(key: key);

  void _showLanguageSelectionSheet(BuildContext context, TrendingProvider provider) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF1E1E24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...provider.availableLanguages.map((String language) {
                  final isSelected = provider.selectedLanguage == language;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                    title: Text(
                      language[0].toUpperCase() + language.substring(1),
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF1ED760) : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFF1ED760))
                        : null,
                    onTap: () {
                      provider.setLanguage(language);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrendingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Now',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showLanguageSelectionSheet(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Text(
                            provider.selectedLanguage[0].toUpperCase() + provider.selectedLanguage.substring(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
              )
            else if (provider.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    provider.errorMessage,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              )
            else
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                physics: const NeverScrollableScrollPhysics(), // Important: disable scrolling as it's inside another scroll view
                shrinkWrap: true, // Important: let it size itself
                itemCount: provider.trendingSongs.length,
                itemBuilder: (context, index) {
                  final song = provider.trendingSongs[index];
                  return GestureDetector(
                    onTap: () {
                      Provider.of<AudioProvider>(context, listen: false).playQueue(
                        provider.trendingSongs.whereType<SongModel>().toList(),
                        initialIndex: index,
                      );
                      context.push('/playing');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222), // slightly lighter than background
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              song.bestImageUrl.isNotEmpty ? song.bestImageUrl : 'https://via.placeholder.com/60',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.music_note, color: Colors.white54),
                                );
                              },
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
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white70,
                            size: 24,
                          ),
                          const SizedBox(width: 8.0),
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
