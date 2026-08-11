import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../widgets/featured_section.dart';
import '../widgets/home_header.dart';
import '../widgets/recently_played_section.dart';
import '../widgets/trending_now_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Very dark grey background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0), // Space for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 16),
                FeaturedSection(
                  items: DummyData.featuredItems,
                ),
                const SizedBox(height: 16),
                const RecentlyPlayedSection(),
                const SizedBox(height: 16),
                const TrendingNowSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

