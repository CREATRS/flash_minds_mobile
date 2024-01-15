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
  });
  final int step;
  final WordPack selectedWordPack;
  final Language sourceLanguage;
  final Language targetLanguage;
  final Widget Function(int i) childBuilder;
  final Widget Function(int i)? backChildBuilder;

  @override
  BaseStepScreenState createState() => BaseStepScreenState();
}

class BaseStepScreenState extends State<BaseStepScreen> {
  int _flashCardProgress = 0;
  List<GlobalKey<FlipCardState>>? keys;

  @override
  void initState() {
    super.initState();
    if (widget.backChildBuilder != null) {
      keys = List.generate(
        widget.selectedWordPack.words.length,
        (_) => GlobalKey<FlipCardState>(),
      );
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
          _buildCards(widget.childBuilder, widget.backChildBuilder, keys),
          Text(
            '${_flashCardProgress + 1}/${widget.selectedWordPack.words.length}',
            style: TextStyles.pMedium.copyWith(color: AppColors.grey),
          ),
          if (widget.backChildBuilder != null)
            TextIconButton(
              'Reveal',
              icon: Icons.flip,
              iconRotation: 1.5,
              onPressed: () => keys![_flashCardProgress].currentState!.flip(),
            ),
          const Spacer(),
          const Text(
            'Swipe left or right to reveal more cards',
            style: TextStyles.pMedium,
            textAlign: TextAlign.center,
          ),
          LinearProgressIndicator(
            value:
                (_flashCardProgress + 1) / widget.selectedWordPack.words.length,
            color: AppColors.red,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          Text('Step ${widget.step}', style: TextStyles.h2),
          AnimatedSlide(
            duration: duration,
            offset: Offset(
              _flashCardProgress == widget.selectedWordPack.words.length - 1
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
    );
  }

  Widget _buildCards(
    Widget Function(int i) childBuilder,
    Widget Function(int i)? backChildBuilder,
    List<GlobalKey<FlipCardState>>? keys,
  ) {
    return Flexible(
      flex: 4,
      child: PageView.builder(
        itemCount: widget.selectedWordPack.words.length,
        controller: PageController(viewportFraction: 0.75),
        physics: const BouncingScrollPhysics(),
        onPageChanged: (int index) =>
            setState(() => _flashCardProgress = index),
        itemBuilder: (_, i) {
          Card front = Card(
            elevation: 6,
            color: const Color(0xFF82C6E6),
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
                  scale: i == _flashCardProgress ? 1 : 0.8,
                  child: backChildBuilder == null
                      ? front
                      : FlipCard(
                          key: keys![i],
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
