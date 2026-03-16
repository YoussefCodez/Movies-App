import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/usecases/add_to_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_state.dart';

@lazySingleton
class HistoryCubit extends Cubit<HistoryState> {
  final AddToHistoryUseCase addToHistoryUseCase;
  final GetHistoryUseCase getHistoryUseCase;

  HistoryCubit({
    required this.addToHistoryUseCase,
    required this.getHistoryUseCase,
  }) : super(HistoryInitial());

  Future<void> getHistory() async {
    final currentState = state;
    if (currentState is! HistoryLoaded) {
      emit(HistoryLoading());
    }

    final result = await getHistoryUseCase();
    result.fold((failure) => emit(HistoryError(failure.message)), (movies) {
      if (state is HistoryLoaded) {
        final currentMovies = (state as HistoryLoaded).movies;
        if (movies.isEmpty && currentMovies.isNotEmpty) return;
      }
      emit(HistoryLoaded(List.from(movies)));
    });
  }

  Future<void> addToHistory(MovieEntity movie) async {
    final currentState = state;
    if (currentState is HistoryLoaded) {
      final List<MovieEntity> currentMovies = List.from(currentState.movies);
      currentMovies.removeWhere((m) => m.id == movie.id);
      currentMovies.insert(0, movie);
      emit(HistoryLoaded(currentMovies));
    }

    final result = await addToHistoryUseCase(movie);
    result.fold(
      (failure) {
        debugPrint('History Add Error: ${failure.message}');
        getHistory();
      },
      (_) {
        if (state is! HistoryLoaded) {
          getHistory();
        }
      },
    );
  }

  void reset() {
    emit(HistoryInitial());
  }
}
