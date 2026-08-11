import 'package:flutter/material.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../../../../core/presentation/widgets/main_header.dart';
import '../widgets/browse_all_section.dart';
import '../widgets/recent_searches_section.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/trending_right_now_section.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0), // Padding for the bottom nav bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainHeader(
                  title: 'Search',
                  profilePicUrl: DummyData.profilePicUrl,
                ),
                const SearchBarWidget(),
                RecentSearchesSection(
                  recentSearches: DummyData.recentSearches,
                ),
                TrendingRightNowSection(
                  items: DummyData.searchTrendingItems,
                ),
                BrowseAllSection(
                  categories: DummyData.browseCategories,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

