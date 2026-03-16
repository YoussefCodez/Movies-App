import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/wishlist_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(MovieEntity movie) {
    return repository.addToWishlist(movie);
  }
}
