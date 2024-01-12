import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';
import 'package:flash_minds/widgets/components/text_icon_button.dart';

class Step1 extends StatefulWidget {
  const Step1({
    super.key,
    required this.selectedWordPack,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
  final WordPack selectedWordPack;
  final Language sourceLanguage;
  final Language targetLanguage;

  @override
  Step1State createState() => Step1State();
}

class Step1State extends State<Step1> {
  int _flashCardProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhrasePack', style: TextStyles.h1),
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
          Expanded(
            flex: 4,
            child: PageView.builder(
              itemCount: widget.selectedWordPack.words.length,
              controller: PageController(viewportFraction: 0.75),
              physics: const BouncingScrollPhysics(),
              onPageChanged: (int index) =>
                  setState(() => _flashCardProgress = index),
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    Expanded(
                      child: AnimatedScale(
                        duration: duration,
                        scale: i == _flashCardProgress ? 1 : 0.8,
                        child: Card(
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
                                Column(
                                  children: [
                                    Text(
                                      widget.selectedWordPack.words[i]
                                          .get(widget.sourceLanguage.code),
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
                                      widget.selectedWordPack.words[i]
                                          .get(widget.targetLanguage.code),
                                      style: TextStyles.h1.copyWith(
                                        color: Colors.white,
                                        shadows: TextStyles.shadows,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: widget.targetLanguage.image(width: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Text(
            '${_flashCardProgress + 1}/${widget.selectedWordPack.words.length}',
            style: TextStyles.pMedium.copyWith(color: AppColors.grey),
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
          const Text('Step 1', style: TextStyles.h2),
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
}
