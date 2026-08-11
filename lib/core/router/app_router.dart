import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/main_layout.dart';
import '../../features/home_screen/presentation/screens/home_screen.dart';
import '../../features/search_screen/presentation/screens/search_screen.dart';
import '../../features/playing_screen/presentation/screens/playing_screen.dart';
import '../../features/wishlist_screen/presentation/screens/wishlist_screen.dart';
import '../../features/profile_screen/presentation/screens/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorSearchKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSearch');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Full screen route outside the bottom nav shell
    GoRoute(
      path: '/playing',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PlayingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: child,
          );
        },
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the MainLayout widget that wraps our navigation shell
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        // Branch for Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),
        // Branch for Search
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            GoRoute(
              path: '/search',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchScreen(),
              ),
            ),
          ],
        ),
        // Branch for Wishlist
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wishlist',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: WishlistScreen(),
              ),
            ),
          ],
        ),
        // Branch for Profile (index 3 now)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

