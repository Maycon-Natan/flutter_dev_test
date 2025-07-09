abstract class LoginResult {}

class LoginSuccessResult extends LoginResult {
  final String message;
  final int? statusCode;

  LoginSuccessResult(this.message, {this.statusCode});
}

class LoginFailureResult extends LoginResult {
  final String message;
  final int? statusCode;

  LoginFailureResult(this.message, {this.statusCode});
}

class RecoverySecretSuccessResult extends LoginResult {
  final String message;
  final String totpSecret;

  RecoverySecretSuccessResult(this.message, this.totpSecret);
}

class RecoverySecretFailureResult extends LoginResult {
  final String message;

  RecoverySecretFailureResult(this.message);
}
