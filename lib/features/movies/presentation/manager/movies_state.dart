import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_entity.dart';

abstract class MoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesSuccess extends MoviesState {
  final List<MovieEntity> topRatedMovies;
  final Map<String, List<MovieEntity>> moviesByCategory;

  MoviesSuccess({required this.topRatedMovies, required this.moviesByCategory});

  @override
  List<Object?> get props => [topRatedMovies, moviesByCategory];
}

class MoviesFailure extends MoviesState {
  final String errorMessage;

  MoviesFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
