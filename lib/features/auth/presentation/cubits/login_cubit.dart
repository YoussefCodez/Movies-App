import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

// States
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  bool isPasswordVisible = false;

  LoginCubit({required AuthRepository authRepository})
    : _repository = authRepository,
      super(LoginInitial());

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginInitial());
  }

  Future<void> loginWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginFailure('Please fill all fields'));
      return;
    }
    emit(LoginLoading());
    try {
      await _repository.signInWithEmail(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      final user = await _repository.signInWithGoogle();
      if (user != null)
        emit(LoginSuccess());
      else
        emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
