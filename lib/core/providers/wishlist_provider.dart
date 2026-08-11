import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/search_screen/data/models/song_model.dart';

class WishlistProvider extends ChangeNotifier {
  static const String _wishlistKey = 'wishlist_songs';
  
  List<SongModel> _wishlist = [];
  List<SongModel> get wishlist => _wishlist;

  WishlistProvider() {
    _loadWishlist();
    // Re-load when auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _loadWishlist();
    });
  }

  Future<void> _loadWishlist() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Load from Firestore
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('wishlist')) {
          final List<dynamic> firestoreList = doc.data()!['wishlist'];
          _wishlist = firestoreList.map((item) => SongModel.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          // New user, ensure empty wishlist
          _wishlist = [];
        }
        notifyListeners();
        return; // Skip local load
      }

      // If we reach here, user is NULL (Guest)
      // Load from local SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? wishlistJson = prefs.getString(_wishlistKey);
      
      if (wishlistJson != null) {
        final List<dynamic> decodedList = jsonDecode(wishlistJson);
        _wishlist = decodedList.map((item) => SongModel.fromJson(item)).toList();
      } else {
        _wishlist = [];
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  bool isWishlisted(String id) {
    return _wishlist.any((song) => song.id == id);
  }

  Future<void> toggleWishlist(SongModel song) async {
    try {
      final bool exists = isWishlisted(song.id);
      
      if (exists) {
        _wishlist.removeWhere((s) => s.id == song.id);
      } else {
        _wishlist.insert(0, song);
      }
      
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'wishlist': _wishlist.map((s) => s.toJson()).toList(),
        });
      } else {
        // Save to Local
        final prefs = await SharedPreferences.getInstance();
        final String encodedList = jsonEncode(_wishlist.map((s) => s.toJson()).toList());
        await prefs.setString(_wishlistKey, encodedList);
      }
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  Future<void> clearWishlist() async {
    _wishlist.clear();
    notifyListeners();
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'wishlist': [],
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_wishlistKey);
    }
  }
}
