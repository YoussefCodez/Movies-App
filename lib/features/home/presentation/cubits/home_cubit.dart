import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
class HomeState extends Equatable {
  final int currentCarouselIndex;
  final List<String> availableNowMovies;
  final List<String> actionMovies;

  const HomeState({
    this.currentCarouselIndex = 0,
    required this.availableNowMovies,
    required this.actionMovies,
  });

  @override
  List<Object?> get props => [
    currentCarouselIndex,
    availableNowMovies,
    actionMovies,
  ];

  HomeState copyWith({
    int? currentCarouselIndex,
    List<String>? availableNowMovies,
    List<String>? actionMovies,
  }) {
    return HomeState(
      currentCarouselIndex: currentCarouselIndex ?? this.currentCarouselIndex,
      availableNowMovies: availableNowMovies ?? this.availableNowMovies,
      actionMovies: actionMovies ?? this.actionMovies,
    );
  }
}

// Cubit
class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
    : super(
        const HomeState(
          availableNowMovies: [
            "assets/images/cursol1.png",
            "assets/images/cursol2.png",
            "assets/images/cursol3.png",
          ],
          actionMovies: [
            "assets/images/cursol1.png",
            "assets/images/cursol2.png",
            "assets/images/cursol3.png",
          ],
        ),
      );

  void onCarouselPageChanged(int index) {
    emit(state.copyWith(currentCarouselIndex: index));
  }
}
