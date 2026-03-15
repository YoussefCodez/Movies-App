import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/movies/domain/usecases/get_similar_movies_usecase.dart';
import '../../../movies/domain/usecases/get_movie_details_usecase.dart';
import 'movie_details_state.dart';

@injectable
class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;
  final GetSimilarMoviesUseCase getSimilarMoviesUseCase;

  MovieDetailsCubit(
    this.getMovieDetailsUseCase,
    this.getSimilarMoviesUseCase,
  ) : super(MovieDetailsInitial());

  Future<void> loadMovie(int movieId) async {
    emit(MovieDetailsLoading());
    
    final detailsResult = await getMovieDetailsUseCase.call(movieId);
    
    detailsResult.fold(
      (exception) => emit(MovieDetailsFailure(exception.toString())),
      (movie) async {
        final similarResult = await getSimilarMoviesUseCase.call(movieId);
        similarResult.fold(
          (failure) => emit(MovieDetailsSuccess(movie, const [])),
          (similarMovies) => emit(MovieDetailsSuccess(movie, similarMovies)),
        );
      },
    );
  }
}
