import 'package:flutter/material.dart';

double _animation = 0;

class ShakeWidget extends StatelessWidget {
  const ShakeWidget({
    super.key,
    required this.controller,
    this.enabled = true,
    required this.child,
  });

  final ShakeWidgetController controller;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: enabled ? 0 : 1, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, animation, child) {
        _animation = animation;
        return Transform.translate(
          offset: Offset(20 * controller.shake(), 0),
          child: child,
        );
      },
      child: child,
    );
  }
}

class ShakeWidgetController {
  double shake() =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(_animation)).abs());
}
