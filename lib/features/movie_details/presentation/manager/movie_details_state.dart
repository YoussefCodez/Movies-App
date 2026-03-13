import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieEntity movie;

  MovieDetailsSuccess(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieDetailsFailure extends MovieDetailsState {
  final String errorMessage;

  MovieDetailsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
