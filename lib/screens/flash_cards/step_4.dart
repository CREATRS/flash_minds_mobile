import 'dart:math' show Random;

import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/word.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/screens/flash_cards/base_step_screen.dart';
import 'package:flash_minds/utils/constants.dart';

class Step4 extends StatefulWidget {
  const Step4({
    super.key,
    required this.selectedWordPack,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.replay,
  });
  final WordPack selectedWordPack;
  final Language sourceLanguage;
  final Language targetLanguage;
  final void Function() replay;

  @override
  State<Step4> createState() => _Step4State();
}

class _Step4State extends State<Step4> {
  int index = 0, correct = 0, incorrect = 0;
  GlobalKey<BaseStepScreenState> baseStepKey = GlobalKey<BaseStepScreenState>();

  late List<bool?> answers;
  late List<List<String>> options;

  @override
  void initState() {
    super.initState();
    List<Word> words = widget.selectedWordPack.words;
    answers = List.generate(words.length, (_) => null);
    options = List.generate(words.length, (i) {
      int randInt = Random().nextInt(words.length);
      while (randInt == i) {
        randInt = Random().nextInt(words.length);
      }
      List<String> opt = [
        words[i].get(widget.targetLanguage.code),
        words[randInt].get(widget.targetLanguage.code),
      ];
      opt.shuffle();
      return opt;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect(int i, int j) {
      return options[i][j] ==
          widget.selectedWordPack.words[index].get(widget.targetLanguage.code);
    }

    void onPressed(int i) async {
      if (answers[index] != null) {
        return;
      }

      bool answer = isCorrect(index, i);
      if (answer) {
        correct++;
        Future.delayed(duration, () => baseStepKey.currentState?.nextPage());
      } else {
        incorrect++;
      }
      setState(() {
        answers[index] = answer;
      });
      if (correct + incorrect == widget.selectedWordPack.words.length) {
        Future.delayed(
          const Duration(seconds: 1),
          () async {
            dynamic replay = await Navigator.of(context).popAndPushNamed(
              Routes.flashCardsCompleted,
              result: true,
              arguments: {
                'correct': correct,
                'incorrect': incorrect,
                'word_pack_id': widget.selectedWordPack.id,
              },
            );
            if (replay == true) {
              widget.replay();
            }
          },
        );
      }
    }

    return BaseStepScreen(
      4,
      key: baseStepKey,
      selectedWordPack: widget.selectedWordPack,
      sourceLanguage: widget.sourceLanguage,
      targetLanguage: widget.targetLanguage,
      childBuilder: (int i) => Text(
        widget.selectedWordPack.words[i].get(widget.sourceLanguage.code),
        style: TextStyles.h1.copyWith(
          color: Colors.white,
          shadows: TextStyles.shadows,
        ),
        textAlign: TextAlign.center,
      ),
      bottomWidget: Column(
        children: [
          ...List.generate(
            2,
            (int i) => ElevatedButton(
              onPressed: () => onPressed(i),
              style: ElevatedButton.styleFrom(
                backgroundColor: answers[index] == null
                    ? AppColors.blue
                    : isCorrect(index, i)
                        ? Colors.green
                        : answers[index] == true
                            ? AppColors.blue
                            : AppColors.red,
              ),
              child: Text(options[index][i]),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Attempted: ${correct + incorrect}'),
              Text('Correct: $correct'),
              Text('Incorrect: $incorrect'),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      spaceAfterBottomWidget: false,
      requiresCompletion: true,
      onPageChanged: (int i) => setState(() => index = i),
    );
  }
}
