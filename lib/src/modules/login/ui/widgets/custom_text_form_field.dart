import 'package:flutter/material.dart';
import 'package:flutter_dev_test/src/utils/constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomTextFormField(
      {super.key, required this.label, this.validator, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textOnBackground),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
        fillColor: const Color.fromRGBO(248, 248, 250, 1.0),
        filled: true,
      ),
    );
  }
}
