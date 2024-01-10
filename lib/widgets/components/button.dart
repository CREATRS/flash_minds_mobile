import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:flash_minds/utils/constants.dart';

export 'package:rounded_loading_button/rounded_loading_button.dart'
    show RoundedLoadingButtonController;

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.controller,
    this.color,
    this.width = 300,
    this.resetAfterDuration = false,
    required this.onPressed,
  });

  final String text;
  final RoundedLoadingButtonController? controller;
  final Color? color;
  final double width;
  final bool resetAfterDuration;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: controller ?? RoundedLoadingButtonController(),
      onPressed: onPressed,
      color: color ?? Theme.of(context).primaryColor,
      width: width,
      height: width * 0.15,
      animateOnTap: controller == null,
      elevation: 7,
      successColor: color,
      resetDuration: const Duration(seconds: 2),
      resetAfterDuration: resetAfterDuration,
      child: Text(text, style: TextStyles.h3.copyWith(color: Colors.white)),
    );
  }
}
