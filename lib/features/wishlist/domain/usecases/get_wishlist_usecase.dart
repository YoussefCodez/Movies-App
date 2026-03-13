import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/wishlist_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetWishlistUseCase {
  final WishlistRepository repository;

  GetWishlistUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call() {
    return repository.getWishlist();
  }
}
