import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_bloc.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_event.dart';
import 'package:flutter_dev_test/src/modules/login/blocs/auth_state.dart';
import 'package:flutter_dev_test/src/modules/login/ui/widgets/otp_input_fields.dart';
import 'package:flutter_dev_test/src/utils/constants/app_colors.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RecoverySecretPage extends StatefulWidget {
  const RecoverySecretPage({super.key});

  @override
  State<RecoverySecretPage> createState() => _RecoverySecretPageState();
}

class _RecoverySecretPageState extends State<RecoverySecretPage> {
  final int _otpLength = 6;
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  String? _code;
  bool _isOtpComplete = false;
  String? _email;
  String? _password;
  bool _argumentsLoaded = false;
  bool _isLoadingArguments = true;
  String? _totp;

  @override
  void initState() {
    _otpControllers = List.generate(
      _otpLength,
      (index) => TextEditingController(),
    );
    _otpFocusNodes = List.generate(
      _otpLength,
      (index) => FocusNode(),
    );

    for (var controller in _otpControllers) {
      controller.addListener(_checkOtpComplete);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _otpFocusNodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.removeListener(_checkOtpComplete);
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Só tentamos carregar os argumentos uma vez para evitar loops com setState
    if (_isLoadingArguments) {
      // Usamos _isLoadingArguments como um guarda
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is Map<String, String>) {
        setState(() {
          _email = arguments['email'];
          _password = arguments['password'];
          _argumentsLoaded = (_email != null && _password != null);
          _isLoadingArguments = false;
        });
        if (!_argumentsLoaded) {
          _handleMissingArguments(); // Se email ou password ainda forem nulos após o cast
        }
      } else {
        // Argumentos não existem ou não são do tipo esperado
        setState(() {
          _argumentsLoaded = false;
          _isLoadingArguments = false;
        });
        _handleMissingArguments();
      }
    }
  }

  void _handleMissingArguments() {
    // Usamos addPostFrameCallback para garantir que a navegação ou o SnackBar
    // aconteçam depois que o frame atual de build estiver completo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Verifique se o widget ainda está montado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Erro: Dados necessários para esta página não foram fornecidos. Redirecionando...'),
            backgroundColor: Colors.red,
          ),
        );
        // Redireciona para a tela de login (ou a rota inicial '/')
        // Usamos pushNamedAndRemoveUntil para limpar a pilha de navegação até a rota inicial
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    });
  }

  void _checkOtpComplete() {
    final allFilled =
        _otpControllers.every((controller) => controller.text.length == 1);
    if (allFilled != _isOtpComplete) {
      setState(() {
        _isOtpComplete = allFilled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.primary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is GetRecoverySecretSuccess) {
          Navigator.pop(context, state.otp);
        } else if (state is GetRecoverySecretFailure) {
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
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Verificação',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 5),
                const Text('Insira o código que foi enviado:',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    )),
                const SizedBox(height: 75),
                Form(
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) {
                          return OtpInputFields(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            previousFocusNode:
                                index > 0 ? _otpFocusNodes[index - 1] : null,
                            nextFocusNode: index < _otpLength - 1
                                ? _otpFocusNodes[index + 1]
                                : null,
                            onChanged: (value) {
                              debugPrint('aqui' + value.toString());
                              _code = _otpControllers
                                  .map((controller) => controller.text)
                                  .join('');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: _isOtpComplete
                      ? () {
                          debugPrint('n entrou');
                          _code = _otpControllers
                              .map((controller) => controller.text)
                              .join('');
                          debugPrint(_code);
                          debugPrint(_email);
                          debugPrint(_password);
                          if (_code != null &&
                              _email != null &&
                              _password != null) {
                            debugPrint('entrou');
                            context.read<AuthBloc>().add(RecoverySecretEvent(
                                email: _email!,
                                password: _password!,
                                code: _code!));
                          }
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isOtpComplete
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconsaxPlusLinear.message_question,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text('Não recebi o código',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textOnBackground,
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
