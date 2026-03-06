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
