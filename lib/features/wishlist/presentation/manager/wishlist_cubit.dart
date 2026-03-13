import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/is_in_wishlist_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';
import 'wishlist_state.dart';

@lazySingleton
class WishlistCubit extends Cubit<WishlistState> {
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;
  final GetWishlistUseCase getWishlistUseCase;
  final IsInWishlistUseCase isInWishlistUseCase;

  WishlistCubit({
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
    required this.getWishlistUseCase,
    required this.isInWishlistUseCase,
  }) : super(WishlistInitial());

  Future<void> getWishlist() async {
    final currentState = state;
    if (currentState is! WishlistLoaded) {
      emit(WishlistLoading());
    }

    final result = await getWishlistUseCase();
    result.fold((failure) => emit(WishlistError(failure.message)), (movies) {
      if (state is WishlistLoaded) {
        final currentMovies = (state as WishlistLoaded).movies;
        if (movies.isEmpty && currentMovies.isNotEmpty) return;
      }
      emit(WishlistLoaded(List.from(movies)));
    });
  }

  Future<void> toggleWishlist(MovieEntity movie) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      final List<MovieEntity> currentMovies = List.from(currentState.movies);
      final isExisting = currentMovies.any((m) => m.id == movie.id);

      if (isExisting) {
        currentMovies.removeWhere((m) => m.id == movie.id);
        emit(WishlistLoaded(currentMovies));
        final result = await removeFromWishlistUseCase(movie.id);
        result.fold((failure) {
          debugPrint('Wishlist Remove Error: ${failure.message}');
          getWishlist();
        }, (_) {});
      } else {
        currentMovies.add(movie);
        emit(WishlistLoaded(currentMovies));
        final result = await addToWishlistUseCase(movie);
        result.fold((failure) {
          debugPrint('Wishlist Add Error: ${failure.message}');
          getWishlist();
        }, (_) {});
      }
    } else {
      emit(WishlistLoading());
      final result = await addToWishlistUseCase(movie);
      result.fold(
        (failure) => emit(WishlistError(failure.message)),
        (_) => getWishlist(),
      );
    }
  }

  bool isMovieInWishlist(int movieId) {
    if (state is WishlistLoaded) {
      return (state as WishlistLoaded).movies.any((m) => m.id == movieId);
    }
    return false;
  }

  void reset() {
    emit(WishlistInitial());
  }
}
