import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/main_header.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../widgets/filter_chips_section.dart';
import '../widgets/library_header.dart';
import '../widgets/library_list_item.dart';

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
              profilePicUrl: DummyData.profilePicUrl,
            ),
            const LibraryHeader(),
            const SizedBox(height: 8),
            const FilterChipsSection(
              filters: ['All', 'Playlists', 'Albums', 'Artists'],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100.0), // Space for nav bar
                itemCount: DummyData.libraryItems.length,
                itemBuilder: (context, index) {
                  return LibraryListItem(
                    item: DummyData.libraryItems[index],
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
