import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/playlist_model.dart';
import '../../features/search_screen/data/models/song_model.dart';

class PlaylistProvider extends ChangeNotifier {
  static const String _localKey = 'user_playlists';
  static const _uuid = Uuid();

  List<PlaylistModel> _playlists = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<PlaylistModel> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  PlaylistProvider() {
    _init();
    FirebaseAuth.instance.authStateChanges().listen((_) => _init());
  }

  // ───────────────────────── Initialise ─────────────────────────

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _loadFromFirestore(user.uid);
      } else {
        await _loadFromLocal();
      }
    } catch (e) {
      debugPrint('[PlaylistProvider] init error: $e');
      _errorMessage = 'Failed to load playlists.';
      // Fall back to local on any unexpected error
      await _loadFromLocal();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ───────────────────────── Load ────────────────────────────────

  /// Reads playlists from the user document field 'playlists' (same pattern as wishlist).
  Future<void> _loadFromFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 5));

      if (doc.exists && doc.data() != null && doc.data()!.containsKey('playlists')) {
        final List<dynamic> raw = doc.data()!['playlists'];
        _playlists = raw
            .map((e) => PlaylistModel.fromJson(e as Map<String, dynamic>))
            .toList();
        // Also sync local cache for offline access
        await _persistToLocal();
      } else {
        // New user / no playlists saved yet
        _playlists = [];
      }
    } catch (e) {
      // Offline or timeout — fall back to local cache without overwriting Firestore
      debugPrint('[PlaylistProvider] Firestore load failed, using local cache: $e');
      await _loadFromLocal();
    }
  }

  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localKey);
      if (raw != null) {
        final List<dynamic> decoded = jsonDecode(raw);
        _playlists = decoded
            .map((e) => PlaylistModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _playlists = [];
      }
    } catch (e) {
      debugPrint('[PlaylistProvider] local load error: $e');
      _playlists = [];
    }
  }

  // ───────────────────────── Save ────────────────────────────────

  Future<void> _persist() async {
    // Always save locally first (instant, never fails)
    await _persistToLocal();

    // Then try Firestore for logged-in users
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _persistToFirestore(user.uid);
      } catch (e) {
        debugPrint('[PlaylistProvider] Firestore save failed (data is safe locally): $e');
      }
    }
  }

  /// Saves playlists as a field on the user document — identical pattern to WishlistProvider.
  Future<void> _persistToFirestore(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'playlists': _playlists.map((p) => p.toJson()).toList(),
    });
  }

  Future<void> _persistToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_playlists.map((p) => p.toJson()).toList());
      await prefs.setString(_localKey, encoded);
    } catch (e) {
      debugPrint('[PlaylistProvider] local save error: $e');
    }
  }

  // ───────────────────────── Public API ──────────────────────────

  /// Creates a new empty playlist with [title].
  Future<PlaylistModel> createPlaylist(String title) async {
    final id = _uuid.v4();
    final pl = PlaylistModel(
      id: id,
      title: title.trim(),
      songs: [],
      createdAt: DateTime.now(),
    );
    _playlists.insert(0, pl);
    notifyListeners();
    await _persist();
    return pl;
  }

  /// Adds [song] to playlist with [playlistId].
  /// Returns false if the song is already in the playlist.
  Future<bool> addSongToPlaylist(String playlistId, SongModel song) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return false;

    final pl = _playlists[index];
    if (pl.containsSong(song.id)) return false; // duplicate guard

    final updated = pl.copyWith(songs: [...pl.songs, song]);
    _playlists[index] = updated;
    notifyListeners();
    await _persist();
    return true;
  }

  /// Removes [songId] from playlist with [playlistId].
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final pl = _playlists[index];
    final updated = pl.copyWith(
      songs: pl.songs.where((s) => s.id != songId).toList(),
    );
    _playlists[index] = updated;
    notifyListeners();
    await _persist();
  }

  /// Deletes the entire playlist with [playlistId].
  Future<void> deletePlaylist(String playlistId) async {
    _playlists.removeWhere((p) => p.id == playlistId);
    notifyListeners();
    await _persist();
  }

  /// Renames playlist with [playlistId].
  Future<void> renamePlaylist(String playlistId, String newTitle) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    _playlists[index] = _playlists[index].copyWith(title: newTitle.trim());
    notifyListeners();
    await _persist();
  }

  /// Returns true if [songId] is already in playlist [playlistId].
  bool isSongInPlaylist(String playlistId, String songId) {
    final pl = _playlists.firstWhere(
      (p) => p.id == playlistId,
      orElse: () => PlaylistModel(
        id: '',
        title: '',
        songs: [],
        createdAt: DateTime.now(),
      ),
    );
    return pl.containsSong(songId);
  }
}
