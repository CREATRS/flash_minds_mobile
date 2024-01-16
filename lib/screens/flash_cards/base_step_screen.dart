import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';
import 'package:flash_minds/widgets/components/flip_card.dart';
import 'package:flash_minds/widgets/components/text_icon_button.dart';

class BaseStepScreen extends StatefulWidget {
  const BaseStepScreen(
    this.step, {
    super.key,
    required this.selectedWordPack,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.childBuilder,
    this.backChildBuilder,
    this.flipKeys,
    this.bottomWidget,
    this.requiresCompletion = false,
    this.onPageChanged,
  }) : assert(
          backChildBuilder == null || flipKeys != null,
          'If you want to use a backChildBuilder,'
          ' you must provide a list of flipKeys',
        );
  final int step;
  final WordPack selectedWordPack;
  final Language sourceLanguage;
  final Language targetLanguage;
  final Widget Function(int i) childBuilder;
  final Widget Function(int i)? backChildBuilder;
  final List<GlobalKey<FlipCardState>>? flipKeys;
  final Widget? bottomWidget;
  final bool requiresCompletion;
  final void Function(int _)? onPageChanged;

  @override
  BaseStepScreenState createState() => BaseStepScreenState();
}

class BaseStepScreenState extends State<BaseStepScreen> {
  int flashCardProgress = 0;
  bool? isCompleted;

  @override
  void initState() {
    super.initState();
    if (widget.requiresCompletion) {
      isCompleted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Pack', style: TextStyles.h1),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Text(
                'Learn new phrases by swiping left or right',
                style: TextStyles.pMedium.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const Spacer(),
          _buildCards(widget.childBuilder, widget.backChildBuilder),
          Text(
            '${flashCardProgress + 1}/${widget.selectedWordPack.words.length}',
            style: TextStyles.pMedium.copyWith(color: AppColors.grey),
          ),
          if (widget.bottomWidget != null) widget.bottomWidget!,
          const Spacer(),
          const Text(
            'Swipe left or right to reveal more cards',
            style: TextStyles.pMedium,
            textAlign: TextAlign.center,
          ),
          LinearProgressIndicator(
            value:
                (flashCardProgress + 1) / widget.selectedWordPack.words.length,
            color: AppColors.red,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          Text('Step ${widget.step}', style: TextStyles.h2),
          AnimatedSlide(
            duration: duration,
            offset: Offset(
              isCompleted == true ||
                      (isCompleted == null &&
                          flashCardProgress ==
                              widget.selectedWordPack.words.length - 1)
                  ? 0
                  : 1,
              0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextIconButton(
                    'Next step',
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildCards(
    Widget Function(int i) childBuilder,
    Widget Function(int i)? backChildBuilder,
  ) {
    return Flexible(
      flex: 4,
      child: PageView.builder(
        itemCount: widget.selectedWordPack.words.length,
        controller: PageController(viewportFraction: 0.75),
        physics: const BouncingScrollPhysics(),
        onPageChanged: (int index) {
          widget.onPageChanged?.call(index);
          setState(() => flashCardProgress = index);
        },
        itemBuilder: (_, i) {
          Card front = Card(
            elevation: 6,
            color: AppColors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.hardEdge,
            shadowColor: Colors.black38,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            CachedOrAssetImage(
                              widget.selectedWordPack.image,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.selectedWordPack.name,
                                style: TextStyles.h3.copyWith(
                                  color: Colors.white,
                                  shadows: TextStyles.shadows,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.sourceLanguage.image(width: 30),
                    ],
                  ),
                  childBuilder(i),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: widget.targetLanguage.image(width: 30),
                  ),
                ],
              ),
            ),
          );
          return Column(
            children: [
              Expanded(
                child: AnimatedScale(
                  duration: duration,
                  scale: i == flashCardProgress ? 1 : 0.8,
                  child: backChildBuilder == null
                      ? front
                      : FlipCard(
                          key: widget.flipKeys![i],
                          front: front,
                          back: Card(
                            elevation: 6,
                            color: AppColors.lightRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            clipBehavior: Clip.hardEdge,
                            shadowColor: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            CachedOrAssetImage(
                                              widget.selectedWordPack.image,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                widget.selectedWordPack.name,
                                                style: TextStyles.h3.copyWith(
                                                  color: Colors.white,
                                                  shadows: TextStyles.shadows,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      widget.sourceLanguage.image(width: 30),
                                    ],
                                  ),
                                  backChildBuilder(i),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child:
                                        widget.targetLanguage.image(width: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
