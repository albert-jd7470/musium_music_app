import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/audio_provider.dart';

import '../../../../core/presentation/widgets/main_header.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';
import '../widgets/playlist_section.dart';
import '../widgets/recent_searches_section.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/trending_right_now_section.dart';
import '../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onRecentSearchTapped(String query) {
    _searchController.text = query;
    Provider.of<SearchProvider>(context, listen: false).searchSongs(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeader(
              title: 'Search',
            ),
            SearchBarWidget(controller: _searchController),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  if (searchProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                    );
                  }

                  if (searchProvider.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        searchProvider.errorMessage,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  if (searchProvider.searchResults.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      itemCount: searchProvider.searchResults.length,
                      itemBuilder: (context, index) {
                        final song = searchProvider.searchResults[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomNetworkImage(
                              song.bestImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
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
                            style: TextStyle(color: Colors.grey.shade400),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.more_vert, color: Colors.white54),
                          onTap: () {
                            Provider.of<AudioProvider>(context, listen: false).playQueue(
                              searchProvider.searchResults,
                              initialIndex: index,
                            );
                            context.push('/playing');
                          },
                        );
                      },
                    );
                  }

                  // Default view when not searching
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (searchProvider.recentSearches.isNotEmpty)
                            RecentSearchesSection(
                              recentSearches: searchProvider.recentSearches,
                              onSearchTapped: _onRecentSearchTapped,
                              onClearTapped: () {
                                searchProvider.clearRecentSearches();
                              },
                            ),
                          const TrendingRightNowSection(),
                          const PlaylistSection(),
                        ],
                      ),
                    ),
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

