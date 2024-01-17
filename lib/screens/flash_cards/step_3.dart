import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/screens/flash_cards/base_step_screen.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/text_icon_button.dart';

class Step3 extends StatefulWidget {
  const Step3({
    super.key,
    required this.selectedWordPack,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
  final WordPack selectedWordPack;
  final Language sourceLanguage;
  final Language targetLanguage;

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  GlobalKey<BaseStepScreenState> baseStepKey = GlobalKey<BaseStepScreenState>();
  GlobalKey<__AnimatedButtonIconState> buttonKey =
      GlobalKey<__AnimatedButtonIconState>();
  int index = 0;

  late List<TextEditingController> controllers;
  late List<bool?> answers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.selectedWordPack.words.length,
      (_) => TextEditingController(),
    );
    answers = List.generate(widget.selectedWordPack.words.length, (_) => null);
  }

  @override
  Widget build(BuildContext context) {
    bool? answer = answers[index];
    String typed = controllers[index].text.toUpperCase();
    String expected =
        widget.selectedWordPack.words[index].get(widget.targetLanguage.code);

    _AnimatedIconModel checkResponse({int? i, String? typedValue}) {
      i ??= index;
      if (typedValue != null) {
        typed = typedValue.toUpperCase();
        answers[i] = typed.isEmpty ? null : typed == expected;
        baseStepKey.currentState?.setState(() {
          baseStepKey.currentState?.isCompleted =
              answers.every((element) => element == true);
        });
      }

      answer = answers[i];
      return _AnimatedIconsModels.fromValue(answer);
    }

    return BaseStepScreen(
      3,
      key: baseStepKey,
      selectedWordPack: widget.selectedWordPack,
      sourceLanguage: widget.sourceLanguage,
      targetLanguage: widget.targetLanguage,
      childBuilder: (int i) => Column(
        children: [
          Text(
            widget.selectedWordPack.words[i].get(widget.sourceLanguage.code),
            style: TextStyles.h1.copyWith(
              color: Colors.white,
              shadows: TextStyles.shadows,
            ),
            textAlign: TextAlign.center,
          ),
          Icon(Icons.swap_vert, size: 45, color: Colors.grey.shade300),
          TextField(
            controller: controllers[i],
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            textCapitalization: TextCapitalization.characters,
            style: TextStyles.h1.copyWith(
              color: Colors.white,
              shadows: TextStyles.shadows,
            ),
            textAlign: TextAlign.center,
            autocorrect: false,
            onSubmitted: (value) => buttonKey.currentState
                ?.refresh(checkResponse(i: i, typedValue: value)),
          ),
        ],
      ),
      bottomWidget: _AnimatedButtonIcon(
        key: buttonKey,
        icons: _AnimatedIconsModels.values,
        onPressed: () => checkResponse(typedValue: controllers[index].text),
      ),
      requiresCompletion: true,
      onPageChanged: (int i) {
        index = i;
        expected = widget.selectedWordPack.words[index]
            .get(widget.targetLanguage.code);
        buttonKey.currentState?.refresh(checkResponse());
      },
    );
  }
}

class _AnimatedButtonIcon extends StatefulWidget {
  const _AnimatedButtonIcon({
    super.key,
    required this.onPressed,
    required this.icons,
  });
  final _AnimatedIconModel Function() onPressed;
  final List<_AnimatedIconModel> icons;

  @override
  State<_AnimatedButtonIcon> createState() => __AnimatedButtonIconState();
}

class __AnimatedButtonIconState extends State<_AnimatedButtonIcon>
    with SingleTickerProviderStateMixin {
  late _AnimatedIconModel iconToShow;

  void refresh(_AnimatedIconModel icon) => setState(() => iconToShow = icon);

  @override
  void initState() {
    super.initState();
    iconToShow = widget.icons[0];
  }

  @override
  Widget build(BuildContext context) {
    return TextIconButton(
      iconToShow.text,
      iconWidget: AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (child, anim) => RotationTransition(
          turns: child.key == iconToShow.key
              ? Tween<double>(begin: 1.5, end: 1).animate(anim)
              : Tween<double>(begin: .5, end: 1).animate(anim),
          child: ScaleTransition(scale: anim, child: child),
        ),
        child: Icon(key: iconToShow.key, iconToShow.icon),
      ),
      color: iconToShow.color,
      onPressed: () => setState(() => iconToShow = widget.onPressed.call()),
    );
  }
}

class _AnimatedIconModel {
  _AnimatedIconModel(
    this.icon,
    this.text,
    this.color,
  ) : key = ValueKey(icon.codePoint);

  final ValueKey key;
  final IconData icon;
  final String text;
  final Color color;
}

class _AnimatedIconsModels {
  static _AnimatedIconModel check =
      _AnimatedIconModel(Icons.spellcheck, 'Check', AppColors.blue);
  static _AnimatedIconModel success =
      _AnimatedIconModel(Icons.check_circle_outline, 'Success', Colors.green);
  static _AnimatedIconModel failed =
      _AnimatedIconModel(Icons.close, 'Failed', AppColors.red);

  static List<_AnimatedIconModel> get values => [check, success, failed];
  static _AnimatedIconModel fromValue(bool? value) => value == null
      ? check
      : value
          ? success
          : failed;
}
