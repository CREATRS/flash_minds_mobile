import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/utils/constants.dart';

class FlashCards extends StatefulWidget {
  const FlashCards(this.selectedPack, {super.key});

  final WordPack selectedPack;

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flash cards'), centerTitle: true),
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
              onTap: () async {},
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                    ),
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text("Let's Begin"),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
            borderRadius: BorderRadius.circular(11),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Step $index',
                      style: TextStyles.h2.copyWith(color: Colors.white),
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
