import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // Placeholder images for carousel and lists
  // Since we haven't integrated an API yet, we'll use placeholder networked images
  // or define the structure.

  final List<String> availableNowMovies = [
    'https://image.tmdb.org/t/p/w500/iZf0KyrE25z1apesvKQFAMhCybg.jpg', // 1917 Example
    'https://image.tmdb.org/t/p/w500/vSNxAJTlD0r02V8s0BN0nI82n3t.jpg', 
    'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
  ];

  final List<String> actionMovies = [
    'https://image.tmdb.org/t/p/w500/vSNxAJTlD0r02V8s0BN0nI82n3t.jpg',
    'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    'https://image.tmdb.org/t/p/w500/qwgGtvKHIHbcpcQREHByNiJObVj.jpg',
  ];

  int _currentCarouselIndex = 0;
  int get currentCarouselIndex => _currentCarouselIndex;

  void onCarouselPageChanged(int index) {
    _currentCarouselIndex = index;
    notifyListeners();
  }
}
