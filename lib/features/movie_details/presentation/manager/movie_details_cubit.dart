import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/usecases/get_movie_details_usecase.dart';
import 'movie_details_state.dart';

@injectable
class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;

  MovieDetailsCubit(this.getMovieDetailsUseCase) : super(MovieDetailsInitial());

  Future<void> loadMovie(int movieId) async {
    emit(MovieDetailsLoading());
    final result = await getMovieDetailsUseCase.call(movieId);
    result.fold(
      (exception) => emit(MovieDetailsFailure(exception.toString())),
      (movie) => emit(MovieDetailsSuccess(movie)),
    );
  }
}
