import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final bool isObscureText;
  final TextEditingController textEditingController;
  final String hintText;
  const AuthField(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
    );
  }
}
