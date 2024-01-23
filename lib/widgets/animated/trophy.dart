import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';

class AnimatedTrophy extends StatefulWidget {
  const AnimatedTrophy({super.key, required this.particles});
  final int particles;

  @override
  State<AnimatedTrophy> createState() => _AnimatedTrophyState();
}

class _AnimatedTrophyState extends State<AnimatedTrophy>
    with TickerProviderStateMixin {
  late AnimationController circleController, trophyController;
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    Duration duration = const Duration(milliseconds: 500);
    circleController = AnimationController(vsync: this, duration: duration);
    confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    trophyController = AnimationController(vsync: this, duration: duration);
    circleController.forward();
    Future.delayed(
      const Duration(milliseconds: 300),
      () => trophyController
          .forward()
          .whenComplete(() => confettiController.play()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([circleController, trophyController]),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Transform.scale(
              scale: circleController.value * circleController.value,
              child: Image.asset('assets/images/game/circle.png', height: 320),
            ),
            Transform.scale(
              scale: trophyController.value * trophyController.value,
              child: Image.asset('assets/images/game/trophy.png', height: 250),
            ),
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: ConfettiWidget(
                confettiController: confettiController,
                numberOfParticles: widget.particles,
                blastDirection: 4.71238898,
                maxBlastForce: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
