import 'package:flutter/material.dart';
import 'package:witwire/utils/colors.dart';

class TextInput extends StatelessWidget {
  final bool isPassword;
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  const TextInput(
      {super.key,
      this.isPassword = false,
      required this.controller,
      required this.hintText,
      required this.inputType});

  @override
  Widget build(BuildContext context) {
    final border =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          fillColor: loginRegisterInputfieldTextColor,
          hintText: hintText,
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          filled: true,
          contentPadding: const EdgeInsets.all(8)),
      keyboardType: inputType,
      obscureText: isPassword,
    );
  }
}
