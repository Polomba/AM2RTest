import 'package:flutter/material.dart';

enum InputFieldType { email, password, username, message, phoneNumber }

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController? inputController;
  final InputFieldType inputFieldType;
  final TextInputAction? textInputAction;

  const CustomInputField(
      {super.key,
      required this.labelText,
      required this.inputController,
      this.textInputAction,
      required this.inputFieldType});

  get _autoFillHintType {
    switch (inputFieldType) {
      case InputFieldType.email:
        return [AutofillHints.email];
      case InputFieldType.username:
        return [AutofillHints.name];
      case InputFieldType.password:
        return [AutofillHints.password];
      case InputFieldType.phoneNumber:
        return [AutofillHints.telephoneNumber];
      default:
    }
  }

  get _keyboardType {
    switch (inputFieldType) {
      case InputFieldType.email:
        return TextInputType.emailAddress;
      case InputFieldType.username:
        return TextInputType.name;
      case InputFieldType.password:
        return TextInputType.text;
      case InputFieldType.phoneNumber:
        return TextInputType.phone;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: inputController,
      autofillHints: _autoFillHintType,
      textInputAction: textInputAction,
      keyboardType: _keyboardType,
      autocorrect: false,
      cursorColor: Colors.grey,
      obscureText: inputFieldType == InputFieldType.password ? true : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (inputFieldType == InputFieldType.email) {
          if (!value.contains('@')) {
            return 'Por favor, insira um email válido';
          }
        }
        return null;
      },
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          isCollapsed: true,
          labelText: labelText,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          floatingLabelBehavior: FloatingLabelBehavior.never),
    );
  }
}
