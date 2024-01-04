import 'dart:io';

import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import 'package:flash_minds/backend/controllers/game_controller.dart';
import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';
import 'package:flash_minds/widgets/components/shake_widget.dart';
import 'package:flash_minds/widgets/modules/flash_cards.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.wordPack, this.progress});
  final WordPack wordPack;
  final GameProgress? progress;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameController controller;
  late User user;
  AppStateService appState = Get.find<AppStateService>();
  AuthService auth = Get.find<AuthService>();
  final Map<String, ConfettiController> confettiControllers = {};
  final ShakeWidgetController shakeController = ShakeWidgetController();
  String? showAccents;

  @override
  void initState() {
    super.initState();
    user = auth.user.value!;
    controller = GameController(
      wordPack: widget.wordPack,
      sourceLanguage: user.sourceLanguage!,
      targetLanguage: Languages.get(user.targetLanguage!),
      preloadProgress: widget.progress,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size buttonSize = Size(
      MediaQuery.of(context).size.width / 10,
      MediaQuery.of(context).size.height * .07,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.score == 0
              ? () => Navigator.pop(context)
              : controller.progress.completedWordPacks
                      .contains(widget.wordPack.id)
                  ? () => Navigator.pop(context, controller.progress)
                  : () => Get.dialog(
                        AlertDialog(
                          title: const Text('Are you sure?'),
                          content: Text(
                            'You will lose your ${controller.score} points.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ),
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedOrAssetImage(widget.wordPack.image),
            const SizedBox(width: 8),
            Flexible(
              child: Text(widget.wordPack.name, overflow: TextOverflow.fade),
            ),
            const SizedBox(width: 8),
            Image.asset('assets/flags/${user.targetLanguage}.png', width: 24),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Animation
          FlashCards(controller),

          // Word
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              controller.currentWord
                  .split('')
                  .map((a) => controller.attempts.contains(a) ? a : '_')
                  .join(' '),
              style: TextStyles.h1,
              textAlign: TextAlign.center,
              textScaler: controller.currentWord.length > 11
                  ? const TextScaler.linear(0.8)
                  : null,
            ),
          ),
          AnimatedContainer(
            duration: 1.seconds,
            height: controller.win != null ? 20 : 0,
            child: Text(
              controller.win != null ? controller.currentWordSource : '',
              style: TextStyles.h3,
            ),
          ),

          // Keyboard
          Flexible(
            flex: 7,
            child: ShakeWidget(
              key: Key(controller.wrongAttempts.toString()),
              controller: shakeController,
              enabled: controller.attempts.isNotEmpty &&
                  controller.attempts.first != ' ',
              child: Column(
                children: [10, 9, 7].map((length) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: List.generate(
                        length,
                        (index) {
                          if (length == 9) {
                            index += 10;
                          } else if (length == 7) {
                            index += 19;
                          }
                          String character = controller.characters[index];
                          if (confettiControllers[character] == null) {
                            confettiControllers[character] =
                                ConfettiController(duration: 2.seconds);
                          }
                          ConfettiController confettiController =
                              confettiControllers[character]!;
                          List<String> specialCharacters = controller
                                  .targetLanguage
                                  .specialCharacters[character] ??
                              [];
                          return ConfettiWidget(
                            confettiController: confettiController,
                            numberOfParticles: 2,
                            maxBlastForce: 5,
                            minBlastForce: 2,
                            blastDirectionality: BlastDirectionality.explosive,
                            child: specialCharacters.isEmpty
                                ? _characterButton(
                                    character,
                                    confettiController: confettiController,
                                    enableLongPress:
                                        specialCharacters.isNotEmpty,
                                    buttonSize: buttonSize,
                                  )
                                : AnimatedContainer(
                                    duration: duration,
                                    width: buttonSize.width *
                                        (showAccents == character
                                            ? specialCharacters.length + 1
                                            : 1),
                                    height: buttonSize.height,
                                    child: Stack(
                                      children: [
                                        ...specialCharacters.map((accent) {
                                          int index =
                                              specialCharacters.indexOf(accent);
                                          return AnimatedPositioned(
                                            left: showAccents == character
                                                ? (index + 1) * buttonSize.width
                                                : 0,
                                            curve: Curves.easeInOut,
                                            duration: duration,
                                            child: _characterButton(
                                              accent,
                                              confettiController:
                                                  confettiController,
                                              elevation:
                                                  showAccents == character
                                                      ? 2
                                                      : 0,
                                              buttonSize: buttonSize,
                                            ),
                                          );
                                        }),
                                        _characterButton(
                                          character,
                                          specialCharacters: specialCharacters,
                                          confettiController:
                                              confettiController,
                                          enableLongPress:
                                              specialCharacters.isNotEmpty,
                                          buttonSize: buttonSize,
                                        ),
                                      ],
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Score and button
          AnimatedSlide(
            duration: 1.seconds,
            offset: controller.win != null ? Offset.zero : const Offset(0, 3),
            child: controller.win != null && controller.win! ||
                    controller.win == null && controller.score > 0
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        Text(
                          'Score: ${controller.score}\nBest: TODO${user.id}',
                          style: TextStyles.h3,
                        ),
                        const Spacer(),
                        controller.isWordPackCompleted
                            ? ElevatedButton.icon(
                                icon: Transform.flip(
                                  flipX: true,
                                  child: const Icon(Icons.next_plan),
                                ),
                                label: const Text('Change wordpack'),
                                onPressed: () =>
                                    Navigator.pop(context, controller.progress),
                              )
                            : ElevatedButton.icon(
                                icon: const Icon(Icons.next_plan),
                                label: const Text('Next'),
                                onPressed: controller.win != null
                                    ? () async {
                                        await controller.reset(
                                          clearScore: false,
                                        );
                                        setState(() {});
                                      }
                                    : null,
                              ),
                      ],
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      await controller.reset();
                      showAccents = null;
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                  ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _characterButton(
    String character, {
    List<String> specialCharacters = const [],
    bool enableLongPress = false,
    ConfettiController? confettiController,
    double elevation = 2,
    required Size buttonSize,
  }) {
    bool isPressed = controller.attempts.contains(character);
    bool hasChildToPress = !specialCharacters.every(
      (element) => controller.attempts.contains(element),
    );
    return Container(
      width: buttonSize.width,
      height: buttonSize.height,
      padding: const EdgeInsets.all(2),
      child: RawMaterialButton(
        onPressed: controller.isReady
            ? isPressed && hasChildToPress && showAccents != character
                ? () => setState(() => showAccents = character)
                : showAccents == character
                    ? () => setState(() => showAccents = null)
                    : isPressed
                        ? null
                        : () async {
                            setState(() {});
                            bool attempt = await controller.attempt(character);
                            setState(() {});
                            if (attempt) {
                              confettiController?.play();
                            } else {
                              shakeController.shake();
                            }
                            if (controller.characters.contains(character) &&
                                character != showAccents) {
                              showAccents = null;
                            }

                            if (controller.win == null) return;

                            if (controller.win!) {
                              confettiControllers
                                  .forEach((_, value) => value.play());
                              if (controller.score > user.id) {
                                auth.updateUser(
                                  // TODO: Update user score
                                  // bestScore: controller.score,
                                );
                                Get.snackbar(
                                  'New high score!',
                                  'You scored ${controller.score} points!',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                await 3.seconds.delay();
                              }
                              if (controller.isWordPackCompleted) {
                                Get.snackbar(
                                  'Congratulations!',
                                  'You completed the word pack!',
                                  duration: 5.seconds,
                                );
                              }
                            } else {
                              Get.snackbar(
                                'Game over!',
                                'You scored ${controller.score} points!',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
            : null,
        onLongPress: controller.isReady && enableLongPress && !isPressed
            ? () => setState(() => showAccents = character)
            : null,
        fillColor: isPressed ? Colors.grey.shade300 : Colors.grey.shade100,
        elevation: elevation,
        shape: const CircleBorder(),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Text(
              character,
              style: TextStyle(
                fontSize: buttonSize.width * .3,
                color: isPressed
                    ? controller.currentWord.contains(character)
                        ? Colors.green
                        : Colors.red
                    : null,
              ),
            ),
            if (specialCharacters.isNotEmpty)
              const Positioned(
                bottom: 0,
                right: 0,
                width: 5,
                height: 10,
                child: Icon(Icons.arrow_drop_down, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
