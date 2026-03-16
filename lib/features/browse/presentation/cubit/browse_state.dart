import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object?> get props => [];
}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseSuccess extends BrowseState {
  final List<MovieEntity> movies;
  final String selectedGenre;

  const BrowseSuccess({required this.movies, required this.selectedGenre});

  @override
  List<Object?> get props => [movies, selectedGenre];
}

class BrowseEmpty extends BrowseState {
  final String selectedGenre;
  const BrowseEmpty(this.selectedGenre);

  @override
  List<Object?> get props => [selectedGenre];
}

class BrowseError extends BrowseState {
  final String message;
  final String selectedGenre;

  const BrowseError({required this.message, required this.selectedGenre});

  @override
  List<Object?> get props => [message, selectedGenre];
}
