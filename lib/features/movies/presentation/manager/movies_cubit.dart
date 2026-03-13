import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import 'movies_state.dart';

@injectable
class MoviesCubit extends Cubit<MoviesState> {
  final GetMoviesUseCase getMoviesUseCase;

  MoviesCubit(this.getMoviesUseCase) : super(MoviesInitial());

  Future<void> fetchMovies() async {
    emit(MoviesLoading());
    final result = await getMoviesUseCase();
    result.fold(
      (failure) {
        emit(MoviesFailure(failure.message));
      },
      (movies) {
        final topRated = List<MovieEntity>.from(movies)
          ..sort((a, b) => b.rating.compareTo(a.rating));
        final top5 = topRated.take(5).toList();

        final categories = <String, List<MovieEntity>>{};
        for (var movie in movies) {
          for (var genre in movie.genres) {
            if (!categories.containsKey(genre)) {
              categories[genre] = [];
            }
            categories[genre]!.add(movie);
          }
        }

        emit(MoviesSuccess(topRatedMovies: top5, moviesByCategory: categories));
      },
    );
  }
}
