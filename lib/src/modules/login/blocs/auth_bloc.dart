import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_event.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_state.dart';
import 'package:flutter_dev_test/src/modules/login/domain/entities/login_result.dart';
import 'package:flutter_dev_test/src/modules/login/errors/auth_exception.dart';
import 'package:flutter_dev_test/src/modules/login/repositories/auth_repository.dart';
import 'package:flutter_dev_test/src/utils/generate_totp.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  String? _secret;

  AuthBloc(this._authRepository) : super(AuthIdle()) {
    on<LoginEvent>(login);
    on<RecoverySecretEvent>(recoverySecret);
  }

  Future login(LoginEvent event, Emitter emit) async {
    emit(LoginLoading());
    await Future.delayed(const Duration(seconds: 2));

    final result = await _authRepository.login(
        email: event.email, password: event.password, totp: event.totp ?? '');

    if (_secret == null || _secret!.isEmpty) {
      emit(GetRecoverySecretInitial(
          email: event.email, password: event.password));
    } else if (result is LoginSuccessResult) {
      emit(LoginSuccess());
    } else if (result is LoginFailureResult) {
      emit(LoginFailure(
          error: AuthException(result.message,
              statusCode: result.statusCode ?? 0)));
    }
  }

  Future recoverySecret(RecoverySecretEvent event, Emitter emit) async {
    emit(GetRecoverySecretLoading());

    final result = await _authRepository.recoverySecret(
        email: event.email, password: event.password, code: event.code);

    if (result is RecoverySecretSuccessResult) {
      final secret = result.totpSecret;
      final otp = generateTOTP(secret);
      _secret = secret;
      emit(GetRecoverySecretSuccess(otp: otp));
    } else if (result is RecoverySecretFailureResult) {
      emit(GetRecoverySecretFailure(error: AuthException(result.message)));
    }
  }
}
