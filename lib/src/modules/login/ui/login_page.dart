import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_bloc.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_event.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_state.dart';
import 'package:flutter_dev_test/src/modules/login/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_dev_test/src/utils/constants/app_colors.dart';
import 'package:flutter_dev_test/src/utils/constants/app_images.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String? _totp;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _recoverySecretAndGetOtp() async {
    final result = await Navigator.of(context).pushNamed(
      '/recovery-secret',
      arguments: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );
    if (result != null && result is String) {
      setState(() {
        _totp = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is GetRecoverySecretInitial) {
            _recoverySecretAndGetOtp();
          } else if (state is LoginFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(
                    state.message.message,
                    style: const TextStyle(fontSize: 15),
                  ),
                  backgroundColor: AppColors.textPrimary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8))),
                ));
            });
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Login realizado com sucesso!'),
                backgroundColor: Colors.green,
              ));
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }, builder: (context, state) {
          if (state is LoginLoading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.loginImage),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          spacing: 10,
                          children: [
                            CustomTextFormField(
                                label: 'E-mail',
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu e-mail';
                                  }
                                  return null;
                                }),
                            CustomTextFormField(
                                label: 'Senha',
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira sua senha';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(LoginEvent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      totp: _totp));
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: const Text('Entrar',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: InkWell(
                    onTap: () {},
                    child: Text('Esqueci a senha',
                        style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ]),
            ),
          );
        }),
      ),
    );
  }
}
