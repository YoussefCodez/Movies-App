import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/wishlist_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class IsInWishlistUseCase {
  final WishlistRepository repository;

  IsInWishlistUseCase(this.repository);

  Future<Either<Failure, bool>> call(int movieId) {
    return repository.isInWishlist(movieId);
  }
}
