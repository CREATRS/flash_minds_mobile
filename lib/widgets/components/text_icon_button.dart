import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'package:flash_minds/utils/constants.dart';

class TextIconButton extends StatelessWidget {
  const TextIconButton(
    this.text, {
    super.key,
    this.icon = Icons.arrow_forward_ios,
    this.iconRotation,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final double? iconRotation;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 10),
          iconRotation != null
              ? Transform.rotate(angle: pi * iconRotation!, child: Icon(icon))
              : Icon(icon),
        ],
      ),
    );
  }
}
