import 'package:flutter/material.dart';
import 'package:flutter_dev_test/src/utils/constants/app_colors.dart';

class OtpInputFields extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilled;
  final FocusNode? previousFocusNode;
  final FocusNode? nextFocusNode;
  const OtpInputFields(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.onChanged,
      this.onFilled,
      this.previousFocusNode,
      this.nextFocusNode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 54,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        onSaved: (pin) {},
        onChanged: (value) {
          if (value.length == 1) {
            onFilled?.call();
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              focusNode.unfocus();
            }
          } else if (value.isEmpty && previousFocusNode != null) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            focusColor: AppColors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Color.fromRGBO(231, 231, 239, 1)),
            ),
            fillColor: Color.fromRGBO(248, 248, 250, 1.0),
            filled: true),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
