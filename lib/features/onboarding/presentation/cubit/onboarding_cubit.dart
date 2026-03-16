import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/onboarding_entity.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  final List<OnboardingEntity> onboardingPages = [
    OnboardingEntity(
      title: 'Find Your Next Favorite Movie Here',
      description:
          'Get access to a huge library of movies to suit all tastes. You will surely like it.',
      image: 'assets/images/onboarding1.png',
      buttonText: 'Explore Now',
    ),
    OnboardingEntity(
      title: 'Discover Movies',
      description:
          'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      image: 'assets/images/onboarding2.png',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      title: 'Explore All Genres',
      description:
          'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      image: 'assets/images/onboarding3.png',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      title: 'Create Watchlists',
      description:
          'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
      image: 'assets/images/onboarding4.png',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      title: 'Rate, Review, and Learn',
      description:
          'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
      image: 'assets/images/onboarding5.png',
      buttonText: 'Next',
    ),
    OnboardingEntity(
      title: 'Start Watching Now',
      description: '',
      image: 'assets/images/onboarding6.png',
      buttonText: 'Finish',
    ),
  ];

  int _currentIndex = 0;

  Future<void> next() async {
    if (_currentIndex < onboardingPages.length - 1) {
      _currentIndex++;
      emit(OnboardingPageChanged(_currentIndex));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      emit(OnboardingCompleted());
    }
  }

  void back() {
    if (_currentIndex > 0) {
      _currentIndex--;
      emit(OnboardingPageChanged(_currentIndex));
    }
  }
}
