import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final Color? color;
  const CustomFloatingButton(
      {super.key,
      required this.onPressed,
      required this.isLoading,
      required this.text,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            backgroundColor: color,
            fixedSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: isLoading ? const CircularProgressIndicator() : Text(text),
        ),
      ),
    );
  }
}
