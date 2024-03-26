import 'package:flutter/material.dart';

class MapFiltersButton extends StatelessWidget {
  const MapFiltersButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        fixedSize: const Size.fromHeight(50),
        backgroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: const Icon(
        Icons.menu,
        color: Colors.black,
      ),
    );
  }
}
