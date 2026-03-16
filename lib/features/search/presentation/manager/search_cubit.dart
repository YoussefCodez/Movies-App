import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/repositories/movie_repository.dart';
import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final MovieRepository movieRepository;
  Timer? _debounce;

  SearchCubit(this.movieRepository) : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());
      final result = await movieRepository.searchMovies(query);

      result.fold(
        (error) => emit(SearchFailure(error.message)),
        (movies) => emit(SearchSuccess(movies)),
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
