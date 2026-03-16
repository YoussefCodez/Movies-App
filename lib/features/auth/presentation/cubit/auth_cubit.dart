import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:movies/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:movies/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:movies/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:movies/features/auth/domain/use_cases/sign_up_use_case.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LogInUseCase _logInUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  AuthCubit({
    required SignUpUseCase signUpUseCase,
    required LogInUseCase logInUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  }) : _logInUseCase = logInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       super(AuthInitial());

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignUpLoading());
    try {
      final result = await _signUpUseCase.call(email, password, name);

      result.fold(
        (failure) {
          emit(SignUpError(message: "Failed SignUp: $failure"));
        },
        (user) {
          emit(SignUpSuccess(user: user));
        },
      );
    } catch (e) {
      emit(SignUpError(message: e.toString()));
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(LogInLoading());
    try {
      final result = await _logInUseCase.call(email, password);

      result.fold(
        (failure) {
          emit(LogInError(message: "Failed Login: $failure"));
        },
        (user) {
          emit(LogInSuccess(user: user));
        },
      );
    } catch (e) {
      emit(LogInError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      final result = await _signOutUseCase.call();
      result.fold(
        (failure) {
          emit(SignOutError(message: failure));
        },
        (_) {
          emit(SignOutSuccess());
        },
      );
    } catch (e) {
      emit(SignOutError(message: e.toString()));
    }
  }

  Future<void> sendResetEmail(String email) async {
    emit(ResetPasswordLoading());
    try {
      final result = await _resetPasswordUseCase.call(email);
      result.fold(
        (failure) => emit(ResetPasswordError(message: failure)),
        (_) => emit(ResetPasswordSuccess()),
      );
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LogInLoading());
    try {
      final result = await _signInWithGoogleUseCase.call();
      result.fold(
        (failure) => emit(LogInError(message: failure)),
        (user) => emit(LogInSuccess(user: user)),
      );
    } catch (e) {
      emit(LogInError(message: e.toString()));
    }
  }
}
