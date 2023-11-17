// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class SiginPhoneSuccess extends AuthState {}

class SignInEmailSuccess extends AuthState {}

class SendLinkEmailSuccess extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  const AuthError({required this.errorMessage});

  @override
  List<String> get props => [errorMessage];
}

class SignInEmailError extends AuthState {
  final String errorMessage;

  const SignInEmailError({required this.errorMessage});

  @override
  List<String> get props => [errorMessage];
}


class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {
  final UserModel userModel;

  VerifyOtpSuccess({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

class VerifyOtpFailed extends AuthState {
  const VerifyOtpFailed(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final UserModel userModel;

  const RegisterSuccess({
    required this.userModel,
  });

  @override
  List<Object> get props => [userModel];
}

class RegisterFailed extends AuthState {
  const RegisterFailed(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class SignOutSuccess extends AuthState {}

class SignInEmailVerifSuccess extends AuthState {
  final UserModel userModel;

  const SignInEmailVerifSuccess({
    required this.userModel,
  });

  @override
  List<Object> get props => [userModel];
}
