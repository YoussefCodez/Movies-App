part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  final UserEntity user;
  const SignUpSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class SignUpError extends AuthState {
  final String message;
  const SignUpError({required this.message});

  @override
  List<Object> get props => [message];
}

class LogInLoading extends AuthState {}

class LogInSuccess extends AuthState {
  final UserEntity user;
  const LogInSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class LogInError extends AuthState {
  final String message;
  const LogInError({required this.message});

  @override
  List<Object> get props => [message];
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutError extends AuthState {
  final String message;
  const SignOutError({required this.message});

  @override
  List<Object> get props => [message];
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordError extends AuthState {
  final String message;
  const ResetPasswordError({required this.message});

  @override
  List<Object> get props => [message];
}
