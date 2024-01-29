import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'package:flash_minds/utils/constants.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
  });
  final Widget front;
  final Widget back;

  @override
  State<FlipCard> createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) => _status = status);
  }

  void flip() {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0015)
        ..rotateX(pi * _animation.value),
      child: _animation.value <= 0.5
          ? widget.front
          : Transform.flip(flipY: true, child: widget.back),
    );
  }
}
