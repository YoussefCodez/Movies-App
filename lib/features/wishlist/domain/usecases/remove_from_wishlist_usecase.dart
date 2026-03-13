import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/wishlist_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(int movieId) {
    return repository.removeFromWishlist(movieId);
  }
}
