import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/button.dart';
import 'package:flash_minds/widgets/components/word_pack_list_tile.dart';

class LearningTab extends StatelessWidget {
  const LearningTab(this.myProgress, {super.key});
  final List<UserProgress> myProgress;

  @override
  Widget build(BuildContext context) {
    return myProgress.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You have not started any wordpacks yet.',
                  style: TextStyles.pMedium,
                ),
                const SizedBox(height: 16),
                Button(
                  text: "Let's start!",
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, Routes.home),
                ),
              ],
            ),
          )
        : FutureBuilder(
            future: Api.getWordPacksById(myProgress.map((p) => p.id).toList()),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  WordPack wordPack = snapshot.data![index];
                  return WordPackListTile(
                    wordPack,
                    trailing: Text(
                      _getCompletedStepsText(
                        myProgress.singleWhere((p) => p.id == wordPack.id),
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}

String _getCompletedStepsText(UserProgress progress) {
  if (progress.completed.length == 4) {
    return 'Completed';
  }
  String text = progress.completed.length == 1 ? 'Step' : 'Steps';
  progress.completed.sort();
  for (int i = 0; i < progress.completed.length; i++) {
    int step = progress.completed[i];
    if (i == 0) {
      text += ' $step';
    } else if (i < progress.completed.length - 1) {
      text += ', $step';
    } else {
      text += ' and $step';
    }
  }
  return '$text completed';
}
