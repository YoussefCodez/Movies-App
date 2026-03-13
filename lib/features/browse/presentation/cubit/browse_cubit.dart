import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_movies_by_genre_usecase.dart';
import 'browse_state.dart';

@injectable
class BrowseCubit extends Cubit<BrowseState> {
  final GetMoviesByGenreUseCase getMoviesByGenreUseCase;

  BrowseCubit(this.getMoviesByGenreUseCase) : super(BrowseInitial());

  static const List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'Film-Noir',
    'History',
    'Horror',
    'Music',
    'Musical',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Short',
    'Sport',
    'Thriller',
    'War',
    'Western',
  ];

  String _currentGenre = 'Action';

  void changeGenre(String genre) async {
    _currentGenre = genre;
    emit(BrowseLoading());
    final result = await getMoviesByGenreUseCase(genre.toLowerCase());
    result.fold(
      (failure) => emit(
        BrowseError(message: failure.message, selectedGenre: _currentGenre),
      ),
      (movies) {
        if (movies.isEmpty) {
          emit(BrowseEmpty(_currentGenre));
        } else {
          emit(BrowseSuccess(movies: movies, selectedGenre: _currentGenre));
        }
      },
    );
  }

  String get currentGenre => _currentGenre;
}
