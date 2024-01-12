import 'package:flutter/material.dart';

import 'package:flash_minds/utils/constants.dart';

class TextIconButton extends StatelessWidget {
  const TextIconButton(
    this.text, {
    super.key,
    this.icon = Icons.arrow_forward_ios,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
      child: Row(children: [Text(text), const SizedBox(width: 10), Icon(icon)]),
    );
  }
}
