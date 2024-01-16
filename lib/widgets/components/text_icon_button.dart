import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'package:flash_minds/utils/constants.dart';

class TextIconButton extends StatelessWidget {
  const TextIconButton(
    this.text, {
    super.key,
    this.icon = Icons.arrow_forward_ios,
    this.iconWidget,
    this.iconRotation,
    this.color = AppColors.red,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final Widget? iconWidget;
  final double? iconRotation;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 10),
          iconRotation != null
              ? Transform.rotate(angle: pi * iconRotation!, child: Icon(icon))
              : iconWidget != null
                  ? iconWidget!
                  : Icon(icon),
        ],
      ),
    );
  }
}
