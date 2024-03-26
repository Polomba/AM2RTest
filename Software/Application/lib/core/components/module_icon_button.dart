import 'package:flutter/material.dart';

class ModuleIconButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onClick;
  final Color markerColor;
  const ModuleIconButton(
      {super.key,
      required this.isSelected,
      required this.onClick,
      required this.markerColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: isSelected ? 40 : 30,
        height: isSelected ? 40 : 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? markerColor : markerColor.withAlpha(122),
        ),
        child: Container(
          width: isSelected ? 12 : 10,
          height: isSelected ? 12 : 10,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
