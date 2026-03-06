import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/services/get_it.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

enum SplashState { initial, loading, authenticated, unauthenticated }

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  SplashCubit() : super(SplashState.initial);

  Future<void> initSplash() async {
    emit(SplashState.loading);
    await Future.delayed(const Duration(seconds: 3));
    if (_authRepository.isUserLoggedIn()) {
      emit(SplashState.authenticated);
    } else {
      emit(SplashState.unauthenticated);
    }
  }
}
