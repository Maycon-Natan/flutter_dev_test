import 'package:dio/dio.dart';
import 'package:flutter_dev_test/src/modules/login/domain/entities/login_result.dart';

class AuthRepository {
  final dio = Dio();
  final url = 'http://10.0.2.2:5000';

  Future login(
      {required String email, required String password, String? totp}) async {
    try {
      var response = await dio.post(
        "$url/auth/login",
        data: {
          "username": email,
          "password": password,
          "totp_code": totp ?? ''
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return LoginSuccessResult("Login bem-sucedido", statusCode: 200);
      } else if (response.statusCode == 401) {
        return LoginFailureResult("Credenciais inválidas", statusCode: 401);
      } else {
        return LoginFailureResult("Erro no servidor",
            statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      return LoginFailureResult("Erro de rede: ${e.message}");
    } catch (e) {
      return LoginFailureResult("Erro inesperado: ${e.toString()}");
    }
  }

  Future recoverySecret(
      {required String email,
      required String password,
      required String code}) async {
    try {
      var response = await dio.post(
        "$url/auth/recovery-secret",
        data: {"username": email, "password": password, "code": code},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return RecoverySecretSuccessResult(
            "Código de recuperação e senha verificados",
            response.data["totp_secret"]);
      } else if (response.statusCode == 401) {
        if (response.data["message"] == "Invalid password") {
          return RecoverySecretFailureResult("Senha inválida");
        } else if (response.data["message"] == "Invalid recovery code") {
          return RecoverySecretFailureResult("Código inválido");
        }
      } else if (response.statusCode == 404) {
        return RecoverySecretFailureResult("Usuário não encontrado");
      } else {
        return LoginFailureResult("Erro no servidor",
            statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      return LoginFailureResult("Erro de rede: ${e.message}");
    } catch (e) {
      return LoginFailureResult("Erro inesperado: ${e.toString()}");
    }
  }
}
