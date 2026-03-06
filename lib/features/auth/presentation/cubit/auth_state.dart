part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {
  final UserEntity user;

  const SignUpSuccess({required this.user});
}

final class SignUpError extends AuthState {
  final String message;

  const SignUpError({required this.message});
}

final class LogInLoading extends AuthState {}

final class LogInSuccess extends AuthState {
  final UserEntity user;

  const LogInSuccess({required this.user});
}

final class LogInError extends AuthState {
  final String message;

  const LogInError({required this.message});
}

final class SignOutLoading extends AuthState {}

final class SignOutSuccess extends AuthState {}

final class SignOutError extends AuthState {
  final String message;

  const SignOutError({required this.message});
}

final class ResetPasswordLoading extends AuthState {}

final class ResetPasswordSuccess extends AuthState {}

final class ResetPasswordError extends AuthState {
  final String message;

  const ResetPasswordError({required this.message});
}
