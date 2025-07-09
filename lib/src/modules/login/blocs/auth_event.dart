abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  String email;
  String password;
  String? totp;

  LoginEvent({required this.email, required this.password, this.totp});
}

class RecoverySecretEvent extends AuthEvent {
  String email;
  String password;
  String code;

  RecoverySecretEvent(
      {required this.email, required this.password, required this.code});
}
