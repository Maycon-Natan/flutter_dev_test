import 'package:flutter/foundation.dart';

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, {this.statusCode}) {
    _logError();
  }

  void _logError() {
    if (kDebugMode) {
      print("\x1B[31m----------------Response ERROR----------------\x1B[0m");
      print("\x1B[31m- AuthException \x1B[0m");
      print("\x1B[31m- Message: $message\x1B[0m");
      print("\x1B[31m- Status Code: $statusCode\x1B[0m");
      print("\x1B[31m-----------------------------------------\x1B[0m");
    }
  }

  @override
  String toString() => 'AuthException (message: $message)';
}
