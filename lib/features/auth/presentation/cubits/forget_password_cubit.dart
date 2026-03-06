import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

// States
abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String message;
  const ForgetPasswordFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository _repository;

  ForgetPasswordCubit({required AuthRepository authRepository})
    : _repository = authRepository,
      super(ForgetPasswordInitial());

  Future<void> sendResetEmail(String email) async {
    if (email.isEmpty) {
      emit(const ForgetPasswordFailure('Email cannot be empty'));
      return;
    }
    emit(ForgetPasswordLoading());
    try {
      await _repository.resetPassword(email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
