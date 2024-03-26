import 'package:flutter/material.dart';

class RouteDetailsListItem extends StatelessWidget {
  final String leftText;
  final String rightText;
  const RouteDetailsListItem(
      {super.key, required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(rightText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ))
        ],
      ),
    );
  }
}
