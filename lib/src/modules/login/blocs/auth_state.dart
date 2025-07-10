import 'package:flutter_dev_test/src/modules/login/errors/auth_exception.dart';

abstract class AuthState {}

class AuthIdle extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final AuthException error;

  LoginFailure({required this.error});
}

class GetRecoverySecretInitial extends AuthState {
  final String email;
  final String password;

  GetRecoverySecretInitial({required this.email, required this.password});
}

class GetRecoverySecretLoading extends AuthState {}

class GetRecoverySecretSuccess extends AuthState {
  final String otp;

  GetRecoverySecretSuccess({required this.otp});
}

class GetRecoverySecretFailure extends AuthState {
  final AuthException error;

  GetRecoverySecretFailure({required this.error});
}
