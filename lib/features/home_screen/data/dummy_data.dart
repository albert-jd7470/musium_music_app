class FeaturedItem {
  final String title;
  final String subtitle;
  final String imageUrl;

  FeaturedItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class RecentlyPlayedItem {
  final String title;
  final String imageUrl;

  RecentlyPlayedItem({
    required this.title,
    required this.imageUrl,
  });
}

class TrendingItem {
  final String title;
  final String artist;
  final String imageUrl;
  final bool isLiked;

  TrendingItem({
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.isLiked = false,
  });
}

class BrowseCategory {
  final String title;
  final String imageUrl;

  BrowseCategory({
    required this.title,
    required this.imageUrl,
  });
}

class SongDetails {
  final String title;
  final String artist;
  final String albumName;
  final String imageUrl;

  SongDetails({
    required this.title,
    required this.artist,
    required this.albumName,
    required this.imageUrl,
  });
}

class DummyData {
  static const String profilePicUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop';

  static List<FeaturedItem> featuredItems = [
    FeaturedItem(
      title: 'Neon Dreams',
      subtitle: 'Synthwave Sessions',
      imageUrl: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=500&auto=format&fit=crop',
    ),
    FeaturedItem(
      title: 'Canyon Echoes',
      subtitle: 'Indie Folk',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  static List<RecentlyPlayedItem> recentlyPlayedItems = [
    RecentlyPlayedItem(
      title: 'Midnight City',
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a1a2a5f5646c?q=80&w=300&auto=format&fit=crop',
    ),
    RecentlyPlayedItem(
      title: 'Lost in\nWoods',
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=300&auto=format&fit=crop',
    ),
    RecentlyPlayedItem(
      title: 'Beats vol.4',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=300&auto=format&fit=crop',
    ),
    RecentlyPlayedItem(
      title: 'Ocean\nBreeze',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=300&auto=format&fit=crop',
    ),
  ];

  static List<TrendingItem> trendingItems = [
    TrendingItem(
      title: 'Crimson Heart',
      artist: 'Luna Ray',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=300&auto=format&fit=crop',
      isLiked: true,
    ),
    TrendingItem(
      title: 'Nightcall',
      artist: 'The Outrunners',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=300&auto=format&fit=crop',
    ),
    TrendingItem(
      title: 'Rainy Day Blues',
      artist: 'Miles Davis Quartet',
      imageUrl: 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?q=80&w=300&auto=format&fit=crop',
      isLiked: true,
    ),
  ];

  // Search Screen Data
  static List<String> recentSearches = [
    'The Midnight',
    'Lofi Beats',
    'Gunship',
  ];

  static List<TrendingItem> searchTrendingItems = [
    TrendingItem(
      title: 'Neon Nights',
      artist: 'Nightcall',
      imageUrl: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=300&auto=format&fit=crop',
    ),
    TrendingItem(
      title: 'Rain in Tokyo',
      artist: 'Lofi Girl',
      imageUrl: 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?q=80&w=300&auto=format&fit=crop',
    ),
  ];

  static List<BrowseCategory> browseCategories = [
    BrowseCategory(
      title: 'Pop',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=300&auto=format&fit=crop',
    ),
    BrowseCategory(
      title: 'Hip-Hop',
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a1a2a5f5646c?q=80&w=300&auto=format&fit=crop',
    ),
    BrowseCategory(
      title: 'Electronic',
      imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=300&auto=format&fit=crop',
    ),
    BrowseCategory(
      title: 'Indie',
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=300&auto=format&fit=crop',
    ),
  ];

  // Now Playing Data
  static SongDetails currentSong = SongDetails(
    title: 'Midnight Runner',
    artist: 'The Synth Mechanics',
    albumName: 'Neon Nights EP',
    imageUrl: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=800&auto=format&fit=crop',
  );

  // Library / Wishlist Data
  static List<LibraryItem> libraryItems = [
    LibraryItem(
      title: 'Neon Nights',
      artist: 'The Midnight Echoes',
      genre: 'Electronic',
      imageUrl: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=300&auto=format&fit=crop',
      isDownloaded: false,
    ),
    LibraryItem(
      title: 'Autumn Leaves Falling',
      artist: 'Sarah Jenkins',
      genre: 'Acoustic',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=300&auto=format&fit=crop',
      isDownloaded: true,
    ),
    LibraryItem(
      title: 'City Rhythms',
      artist: 'DJ Metro',
      genre: 'Lo-Fi Beats',
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a1a2a5f5646c?q=80&w=300&auto=format&fit=crop',
      isDownloaded: false,
    ),
    LibraryItem(
      title: 'Nocturne in E-Flat Major',
      artist: 'Frederic Chopin',
      genre: 'Classical',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=300&auto=format&fit=crop',
      isDownloaded: false,
    ),
  ];

  // Profile Data
  static UserProfile currentUser = UserProfile(
    name: 'Alex Rivera',
    handle: '@arivera_tunes',
    isPremium: true,
    songsCount: '1.2k',
    playlistsCount: '45',
    listeningHours: '240h',
    profilePicUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
  );
}

class LibraryItem {
  final String title;
  final String artist;
  final String genre;
  final String imageUrl;
  final bool isDownloaded;

  LibraryItem({
    required this.title,
    required this.artist,
    required this.genre,
    required this.imageUrl,
    this.isDownloaded = false,
  });
}

class UserProfile {
  final String name;
  final String handle;
  final bool isPremium;
  final String songsCount;
  final String playlistsCount;
  final String listeningHours;
  final String profilePicUrl;

  UserProfile({
    required this.name,
    required this.handle,
    this.isPremium = false,
    required this.songsCount,
    required this.playlistsCount,
    required this.listeningHours,
    required this.profilePicUrl,
  });
}



