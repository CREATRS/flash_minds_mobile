import 'package:flutter/material.dart';

import 'package:flash_minds/backend/controllers/game_controller.dart';

class FlashCards extends StatefulWidget {
  const FlashCards(this.controller, {super.key});

  final GameController controller;

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
      reverseDuration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      width: size.width,
      height: size.height * .5,
      child: const Text('GAME HERE'),
    );
    // return Lottie.asset(
    //   'assets/animations/FlashCards.json',
    //   alignment: Alignment.center,
    //   fit: BoxFit.contain,
    //   height: min(size.width, size.height * 0.438),
    //   controller: widget.controller.animationController,
    // );
  }
}
