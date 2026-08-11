import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musium_music_app/core/presentation/widgets/mini_player.dart';
import '../../../../features/home_screen/presentation/widgets/custom_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({Key? key, required this.navigationShell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // The current screen
          navigationShell,
          // The persistent bottom navigation bar and mini player
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 MiniPlayer(),
                CustomBottomNavBar(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (index) {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
