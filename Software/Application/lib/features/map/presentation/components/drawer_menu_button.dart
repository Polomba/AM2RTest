import 'package:flutter/material.dart';

class DrawerMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final FontWeight? fontWeight;
  const DrawerMenuButton(
      {super.key, this.onPressed, required this.buttonText, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
