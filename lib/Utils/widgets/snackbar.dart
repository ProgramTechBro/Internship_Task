import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key,
    required this.icon,
    required this.iconColor,
    required this.text,
  }) : super(
    content: Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Text(text),
      ],
    ),
  );

  final IconData icon;
  final Color iconColor;
  final String text;
}
