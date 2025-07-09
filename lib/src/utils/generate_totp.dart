import 'package:otp/otp.dart';

String generateTOTP(String secret) {
  return OTP.generateTOTPCodeString(
    secret,
    DateTime.now().millisecondsSinceEpoch,
    interval: 30,
    algorithm: Algorithm.SHA1,
    isGoogle: true,
  );
}
