import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  // Placeholder for search results
  List<dynamic> _searchResults = [];
  List<dynamic> get searchResults => _searchResults;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    // In a real app, we would trigger an API call here.
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }
}
