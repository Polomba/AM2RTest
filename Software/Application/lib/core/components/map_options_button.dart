import 'package:flutter/material.dart';

class MapOptionsButton extends StatelessWidget {
  const MapOptionsButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.isSelected,
  });

  final bool isSelected;
  final VoidCallback? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8.0),
        decoration: ShapeDecoration(
            color: isSelected ? Colors.black87 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadows: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ]),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}
