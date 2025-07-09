import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/src/modules/home/ui/home_page.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_bloc.dart';
import 'package:flutter_dev_test/src/modules/login/repositories/auth_repository.dart';
import 'package:flutter_dev_test/src/modules/login/ui/login_page.dart';
import 'package:flutter_dev_test/src/modules/login/ui/recovery_secret_page.dart';
import 'package:flutter_dev_test/src/utils/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  final authRepository = AuthRepository();
  runApp(BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/recovery-secret': (context) => const RecoverySecretPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
