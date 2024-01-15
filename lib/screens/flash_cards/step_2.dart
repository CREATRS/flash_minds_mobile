import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/screens/flash_cards/base_step_screen.dart';
import 'package:flash_minds/utils/constants.dart';

class Step2 extends StatelessWidget {
  const Step2({
    super.key,
    required this.selectedWordPack,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
  final WordPack selectedWordPack;
  final Language sourceLanguage;
  final Language targetLanguage;

  @override
  Widget build(BuildContext context) {
    return BaseStepScreen(
      2,
      selectedWordPack: selectedWordPack,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      childBuilder: (int i) => Column(
        children: [
          Text(
            selectedWordPack.words[i].get(sourceLanguage.code),
            style: TextStyles.h1.copyWith(
              color: Colors.white,
              shadows: TextStyles.shadows,
            ),
            textAlign: TextAlign.center,
          ),
          Transform.rotate(
            angle: pi / 2,
            child: Icon(
              Icons.compare_arrows,
              size: 45,
              color: Colors.grey.shade300,
            ),
          ),
          const Text('', style: TextStyles.h1),
        ],
      ),
      backChildBuilder: (int i) => Column(
        children: [
          Text(
            selectedWordPack.words[i].get(sourceLanguage.code),
            style: TextStyles.h1.copyWith(
              color: Colors.white,
              shadows: TextStyles.shadows,
            ),
            textAlign: TextAlign.center,
          ),
          Transform.rotate(
            angle: pi / 2,
            child: Icon(
              Icons.compare_arrows,
              size: 45,
              color: Colors.grey.shade300,
            ),
          ),
          Text(
            selectedWordPack.words[i].get(targetLanguage.code),
            style: TextStyles.h1.copyWith(
              color: Colors.white,
              shadows: TextStyles.shadows,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
