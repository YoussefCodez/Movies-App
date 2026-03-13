import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<MovieEntity> movies;
  const WishlistLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class WishlistError extends WishlistState {
  final String message;
  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}
