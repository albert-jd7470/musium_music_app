import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../data/models/song_model.dart';

class SearchProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  
  List<SongModel> _searchResults = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<SongModel> get searchResults => _searchResults;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  SearchProvider() {
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _saveRecentSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    try {
      // Remove if it already exists to move it to the front
      _recentSearches.removeWhere((q) => q.toLowerCase() == trimmedQuery.toLowerCase());
      _recentSearches.insert(0, trimmedQuery);

      // Keep only the last 10
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.sublist(0, 10);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recentSearches', _recentSearches);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving recent search: $e');
    }
  }

  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recentSearches');
    } catch (e) {
      debugPrint('Error clearing recent searches: $e');
    }
  }

  Future<void> searchSongs(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _errorMessage = '';
      notifyListeners();
      return;
    }

    // Save search immediately when executed
    _saveRecentSearch(query);

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = '${ApiEndpoints.SearchEndpoint}$query&limit=50';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['status'] == 'SUCCESS' && responseData['data'] != null) {
          final List<dynamic> results = responseData['data']['results'] ?? [];
          _searchResults = results.map((json) => SongModel.fromJson(json)).toList();
        } else {
          _searchResults = [];
          _errorMessage = 'No results found.';
        }
      } else {
        _errorMessage = 'Failed to load search results. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearSearch() {
    _searchResults = [];
    _errorMessage = '';
    notifyListeners();
  }
}
