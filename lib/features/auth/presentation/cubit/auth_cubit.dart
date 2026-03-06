import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/use_cases/sign_up_use_case.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  AuthCubit({required SignUpUseCase signUpUseCase})
    : _signUpUseCase = signUpUseCase,
      super(AuthInitial());

  Future<void> signUpWithEmail(
    {required String email,
    required String password,
    required String name,}
  ) async {
    try {
      emit(SignUpLoading());

      final result = await _signUpUseCase.call(
        email,
        password,
        name,
      );

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
}
