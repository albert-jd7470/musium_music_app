import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../data/models/song_model.dart';

class SearchProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  
  List<SongModel> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<SongModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> searchSongs(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _errorMessage = '';
      notifyListeners();
      return;
    }

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
