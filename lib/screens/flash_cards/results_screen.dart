import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/animated/trophy.dart';
import 'package:flash_minds/widgets/components/button.dart';
import 'package:flash_minds/widgets/components/rating_stars.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.correct,
    required this.incorrect,
    required this.wordPackId,
  });
  final int correct;
  final int incorrect;
  final int wordPackId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Center(
            child: Text(
              incorrect == 0 ? 'Congratulations!' : 'Good attempt!',
              style: TextStyles.h1,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedTrophy(particles: incorrect == 0 ? correct : 1),
          const SizedBox(height: 4),
          if (incorrect > 0)
            Text(
              "Despite you don't complete the word pack, you did a great job!",
              style: TextStyles.pLarge.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyles.h2.copyWith(color: AppColors.grey),
              children: [
                const TextSpan(text: 'You learned '),
                TextSpan(
                  text: '$correct',
                  style: const TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' new words!'),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            child: Text('${incorrect == 0 ? 'Replay' : 'Retry'} word pack'),
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            child: const Text('Change word pack'),
            onPressed: () => Navigator.popUntil(
              context,
              (route) => route.settings.name == Routes.selectWordpack,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            child: const Text('Rate word pack'),
            onPressed: () => Get.dialog(RateDialog(wordPackId: wordPackId)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class RateDialog extends StatelessWidget {
  const RateDialog({super.key, required this.wordPackId});
  final int wordPackId;

  @override
  Widget build(BuildContext context) {
    int rating = 5;
    RoundedLoadingButtonController controller =
        RoundedLoadingButtonController();

    return AlertDialog(
      title: const Text('Rate word pack'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingStars(
            startFrom: rating,
            onPressed: (i) {
              rating = i;
              controller.reset();
            },
          ),
        ],
      ),
      actions: [
        Column(
          children: [
            Button(
              text: 'Submit',
              controller: controller,
              onPressed: () async {
                controller.start();
                bool success =
                    await Api.rateWordPack(wordPackId, rating: rating);
                if (success) {
                  controller.success();
                  Get.back();
                  Get.snackbar(
                    'Thank you!',
                    'Your rating has been submitted',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  controller.error();
                  Get.snackbar(
                    'Error!',
                    'Something went wrong',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Maybe later'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
