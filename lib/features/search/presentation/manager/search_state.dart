import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<MovieEntity> movies;
  SearchSuccess(this.movies);

  @override
  List<Object?> get props => [movies];
}

class SearchFailure extends SearchState {
  final String errorMessage;
  SearchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
