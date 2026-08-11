import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'core/router/app_router.dart';
import 'core/providers/audio_provider.dart';
import 'core/providers/history_provider.dart';
import 'core/providers/wishlist_provider.dart';
import 'core/providers/auth_provider.dart';
import 'features/search_screen/presentation/providers/search_provider.dart';
import 'features/home_screen/presentation/providers/trending_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/launcher_icon',
    notificationColor: const Color(0xFF1ED760),
  );

  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProxyProvider<HistoryProvider, AudioProvider>(
          create: (context) => AudioProvider(),
          update: (context, historyProvider, audioProvider) {
            audioProvider?.historyProvider = historyProvider;
            return audioProvider!;
          },
        ),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => TrendingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Musium Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFF1ED760),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1ED760),
          secondary: Color(0xFF1ED760),
          surface: Color(0xFF121212),
          background: Color(0xFF000000),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF000000),
          selectedItemColor: Color(0xFF1ED760),
          unselectedItemColor: Colors.white54,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1ED760),
          foregroundColor: Colors.black,
        ),
      ),
      routerConfig: goRouter,
    );
  }
}
