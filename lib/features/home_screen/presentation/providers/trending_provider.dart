import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../features/search_screen/data/models/song_model.dart';

class TrendingProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  
  List<SongModel> _trendingSongs = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedLanguage = 'hindi';

  final List<String> availableLanguages = ['hindi', 'english', 'tamil', 'telugu', 'punjabi', 'malayalam'];

  List<SongModel> get trendingSongs => _trendingSongs;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedLanguage => _selectedLanguage;

  TrendingProvider() {
    _initLanguage();
  }

  Future<void> _initLanguage() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .timeout(const Duration(seconds: 3));
            
        if (doc.exists && doc.data()!.containsKey('preferredLanguage')) {
          _selectedLanguage = doc.data()!['preferredLanguage'];
        } else {
          _selectedLanguage = prefs.getString('preferredLanguage') ?? 'hindi';
        }
      } else {
        _selectedLanguage = prefs.getString('preferredLanguage') ?? 'hindi';
      }
    } catch (e) {
      debugPrint('Error loading initial language: $e');
    }
    
    fetchTrending(_selectedLanguage);
  }

  Future<void> setLanguage(String language) async {
    if (_selectedLanguage == language) return;
    _selectedLanguage = language;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferredLanguage', language);
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'preferredLanguage': language});
      }
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
    
    fetchTrending(language);
  }

  Future<void> fetchTrending(String language) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = '${ApiEndpoints.GetTrendinglanguages}$language';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['status'] == 'SUCCESS' && responseData['data'] != null) {
          // The API returns an 'albums' array which contains the trending songs for this module.
          final List<dynamic> albums = responseData['data']['albums'] ?? [];
          
          _trendingSongs = albums.map<SongModel?>((json) {
            try {
              return SongModel.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing trending song: $e');
              return null;
            }
          }).where((SongModel? song) => song != null).cast<SongModel>().toList();

        } else {
          _trendingSongs = [];
          _errorMessage = 'No trending data found.';
        }
      } else {
        _errorMessage = 'Failed to load trending data.';
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
        _errorMessage = 'No internet connection.';
      } else {
        _errorMessage = 'Failed to load data. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SongModel?> fetchSongDetails(String songUrl) async {
    try {
      final url = '${ApiEndpoints.GetSong}$songUrl';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['status'] == 'SUCCESS' && responseData['data'] != null) {
          final List<dynamic> results = responseData['data'] is List ? responseData['data'] : [responseData['data']];
          if (results.isNotEmpty) {
            return SongModel.fromJson(results.first);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching song details: $e');
    }
    return null;
  }
}
