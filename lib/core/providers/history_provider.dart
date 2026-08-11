import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/search_screen/data/models/song_model.dart';

class HistoryProvider extends ChangeNotifier {
  static const String _historyKey = 'recently_played_songs';
  static const int _maxHistoryLength = 30;
  
  List<SongModel> _history = [];
  List<SongModel> get recentlyPlayed => _history;

  HistoryProvider() {
    _loadHistory();
    // Re-load when auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Load from Firestore
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('recentlyPlayed')) {
          final List<dynamic> firestoreList = doc.data()!['recentlyPlayed'];
          _history = firestoreList.map((item) => SongModel.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          // New user, ensure empty history
          _history = [];
        }
        notifyListeners();
        return;
      }

      // If we reach here, user is NULL (Guest)
      // Load from local SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_historyKey);
      
      if (historyJson != null) {
        final List<dynamic> decodedList = jsonDecode(historyJson);
        _history = decodedList.map((item) => SongModel.fromJson(item)).toList();
      } else {
        _history = [];
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> addSongToHistory(SongModel song) async {
    try {
      _history.removeWhere((s) => s.id == song.id);
      _history.insert(0, song);
      
      if (_history.length > _maxHistoryLength) {
        _history = _history.sublist(0, _maxHistoryLength);
      }
      
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'recentlyPlayed': _history.map((s) => s.toJson()).toList(),
        }, SetOptions(merge: true));
      } else {
        // Save to Local
        final prefs = await SharedPreferences.getInstance();
        final String encodedList = jsonEncode(_history.map((s) => s.toJson()).toList());
        await prefs.setString(_historyKey, encodedList);
      }
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'recentlyPlayed': [],
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    }
  }
}
