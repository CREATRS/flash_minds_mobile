import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/text_icon_button.dart';

export 'step_1.dart';

class FlashCards extends StatefulWidget {
  const FlashCards(this.selectedPack, {super.key});

  final WordPack selectedPack;

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  final List<int> _completedSteps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash cards', style: TextStyles.h1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Follow these steps and you'll be done!",
              style: TextStyles.pMedium,
            ),
            _stageCard(
              1,
              description: 'Look through the card, '
                  'and guess the foreign language translation',
              color: const Color(0xFF053C5E),
              gradientColor: const Color(0xFF1F3958),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  Routes.flashCardsStep1,
                  arguments: widget.selectedPack,
                ).then((value) async {
                  if (value == true) {
                    Get.snackbar(
                      'Congratulations!',
                      'Step 1 Completed',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    setState(() => _completedSteps.add(1));
                  }
                });
              },
            ),
            _stageCard(
              2,
              description: 'Click on REVEAL, and see if you guessed it right',
              color: const Color(0xFF353652),
              gradientColor: const Color(0xFF4C334D),
              onTap: () async {},
            ),
            _stageCard(
              3,
              description: 'Repeat the same, '
                  'this time guessing the native language translation',
              color: const Color(0xFF643047),
              gradientColor: const Color(0xFF7C2E41),
              onTap: () async {},
            ),
            _stageCard(
              4,
              description: 'Look through the card, '
                  'and guess the foreign language translation',
              color: const Color(0xFF942B3B),
              gradientColor: const Color(0xFFAB2836),
              onTap: () async {},
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextIconButton("Let's Begin", onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stageCard(
    int index, {
    required String description,
    required Color color,
    required Color gradientColor,
    required Future Function() onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color, gradientColor],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        'Step $index',
                        style: TextStyles.h2.copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        width: 24,
                        child: AnimatedScale(
                          duration: duration,
                          scale: _completedSteps.contains(index) ? 1 : 0,
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyles.pMedium.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
