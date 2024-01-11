import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/object_response.dart';
import 'package:flash_minds/backend/models/word.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/utils/validators.dart';
import 'package:flash_minds/widgets/components/button.dart';

List<String> _assets = ['animals', 'fruits', 'colors', 'countries', 'numbers'];

class WordPackForm extends StatefulWidget {
  const WordPackForm({super.key, this.wordPack});
  final WordPack? wordPack;

  @override
  State<WordPackForm> createState() => _WordPackFormState();
}

class _WordPackFormState extends State<WordPackForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Language> selectedLanguages = [];
  List<Word> words = [];
  PageController pageController =
      PageController(viewportFraction: 1 / _assets.length);
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  String errors = '';
  TextEditingController nameController = TextEditingController(),
      wordController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Map wordPointer = {};
  int page = 0;

  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.wordPack != null;
    if (isEdit) {
      nameController.text = widget.wordPack!.name;
      selectedLanguages = widget.wordPack!.languages
          .map((l) => Languages.values.firstWhere((e) => e.code == l))
          .toList();
      words = List.from(widget.wordPack!.words);
      page = _assets.indexOf(
        _assets.firstWhere(
          (a) => a == widget.wordPack!.image.split('/').last.split('.').first,
        ),
      );
      pageController = PageController(
        viewportFraction: 1 / _assets.length,
        initialPage: page,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? 'Edit word pack' : 'Create a new word pack',
                style: TextStyles.h2,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() => page = index);
                  },
                  children: _assets.map(
                    (a) {
                      bool selected = page == _assets.indexOf(a);
                      return AnimatedScale(
                        scale: selected ? 1 : .6,
                        duration: duration,
                        child: InkWell(
                          child: Image.asset(
                            'assets/wordpacks/$a.png',
                            color: selected ? null : Colors.black38,
                            colorBlendMode: BlendMode.srcATop,
                          ),
                          onTap: () => pageController.animateToPage(
                            _assets.indexOf(a),
                            duration: duration,
                            curve: curve,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => requiredValidator(value),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 16),
              const Text('Languages', style: TextStyles.h3),
              _languagesRow(),
              const SizedBox(height: 16),
              const Text('Words', style: TextStyles.h3),
              _wordsList(),
              Text('${words.length} words'),
              Text(
                errors,
                style: TextStyles.pMedium.copyWith(color: Colors.red),
              ),
              Button(
                text: isEdit ? 'Save' : 'Create',
                controller: buttonController,
                resetAfterDuration: true,
                onPressed: () async {
                  FormState state = formKey.currentState!;
                  if (state.validate()) {
                    if (selectedLanguages.length < 2) {
                      setState(() => errors = 'Select at least 2 languages');
                      return;
                    }
                    if (words.isEmpty) {
                      setState(() => errors = 'Add at least 1 word');
                      return;
                    }
                    Word? word = words
                        .where(
                          (w) => !w.hasLanguages(
                            selectedLanguages.map((l) => l.code).toList(),
                          ),
                        )
                        .lastOrNull;
                    if (word != null) {
                      wordPointer = {
                        'word': words.indexOf(word),
                        'lang': selectedLanguages.indexOf(
                          selectedLanguages.firstWhere(
                            (l) => !word.hasLanguages([l.code]),
                          ),
                        ),
                      };
                      focusNode.requestFocus();
                      setState(() => errors = 'Fill all the words');
                      return;
                    }
                    late ObjectResponse response;
                    buttonController.start();
                    if (isEdit) {
                      response = await Api.crudWordPack(
                        id: widget.wordPack!.id,
                        name: nameController.text,
                        asset: 'assets/wordpacks/${_assets[page]}.png',
                        words: words,
                        method: Method.patch,
                      );
                    } else {
                      response = await Api.crudWordPack(
                        name: nameController.text,
                        asset: 'assets/wordpacks/${_assets[page]}.png',
                        words: words,
                        method: Method.post,
                      );
                    }
                    if (!context.mounted) return;

                    if (response.hasErrors) {
                      setState(() => errors = response.errors!.join('\n'));
                      buttonController.error();
                    } else {
                      buttonController.success();
                      await Future.delayed(
                        const Duration(seconds: 1),
                        () => Navigator.pop(context, true),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _languagesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Languages.values
          .map(
            (e) => InkWell(
              borderRadius: BorderRadius.circular(24),
              child: e.image(
                fit: BoxFit.cover,
                disabled: selectedLanguages.isNotEmpty &&
                    !selectedLanguages.contains(e),
              ),
              onTap: () async {
                if (selectedLanguages.contains(e)) {
                  if (selectedLanguages.length < 3) return;
                  if (words.any((w) => w.getOrNull(e.code) != null)) {
                    bool? sure = await Get.dialog(
                      AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text(
                          "The translations you've added will be lost",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (!(sure ?? false)) return;
                  }

                  selectedLanguages.remove(e);
                  for (Word w in words) {
                    w.remove(e.code);
                  }
                } else {
                  List<String> codes = Languages.values
                      .map((l) => l.code)
                      .toList(growable: false);
                  selectedLanguages.add(e);
                  selectedLanguages.sort(
                    (a, b) =>
                        codes.indexOf(a.code).compareTo(codes.indexOf(b.code)),
                  );
                }
                setState(() {});
              },
            ),
          )
          .toList(),
    );
  }

  SizedBox _wordsList() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: min(
        60 + (words.length * 55).toDouble(),
        size.height * .35,
      ),
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: words.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              enabled: selectedLanguages.length > 1,
              leading: const Icon(Icons.add),
              title: const Text('Add word'),
              onTap: () {
                if (words.any((w) => w.toJson().keys.isEmpty)) return;
                setState(() => words.insert(0, Word()));
              },
            );
          }
          Word word = words[index - 1];
          return ListTile(
            title: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: selectedLanguages.map(
                  (l) {
                    String? value = word.getOrNull(l.code);
                    Map<String, int> pointer = {
                      'word': words.indexOf(word),
                      'lang': selectedLanguages.indexOf(l),
                    };
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: l.image().image,
                          opacity: .2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: .5,
                          color: Theme.of(context)
                                  .inputDecorationTheme
                                  .enabledBorder
                                  ?.borderSide
                                  .color ??
                              Colors.black,
                        ),
                      ),
                      width: max(
                        100,
                        size.width / (selectedLanguages.length + .6),
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      child: wordPointer['word'] == pointer['word'] &&
                              wordPointer['lang'] == pointer['lang']
                          ? TextField(
                              controller: wordController,
                              focusNode: focusNode,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (value) {
                                if (wordController.text.isNotEmpty) {
                                  word.set(
                                    l.code,
                                    wordController.text,
                                  );
                                  wordController.clear();
                                }
                                Word? nextValue = words
                                    .where(
                                      (w) => !w.hasLanguages(
                                        selectedLanguages
                                            .map((l) => l.code)
                                            .toList(),
                                      ),
                                    )
                                    .lastOrNull;
                                if (nextValue == null) {
                                  setState(() {
                                    wordPointer = {};
                                  });
                                } else {
                                  wordPointer = {
                                    'word': words.indexOf(nextValue),
                                    'lang': selectedLanguages.indexOf(
                                      selectedLanguages.firstWhere(
                                        (l) =>
                                            !nextValue.hasLanguages([l.code]),
                                      ),
                                    ),
                                  };
                                }
                                setState(() => errors = '');
                              },
                              onTapOutside: (event) {
                                if (wordController.text.isNotEmpty) {
                                  word.set(
                                    l.code,
                                    wordController.text,
                                  );
                                  wordController.clear();
                                }
                                errors = '';
                                setState(() => wordPointer = {});
                              },
                            )
                          : InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      value ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                focusNode.requestFocus();
                                wordController.text = value ?? '';
                                setState(() => wordPointer = pointer);
                              },
                            ),
                    );
                  },
                ).toList(),
              ),
            ),
            trailing: IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete),
              onPressed: () async {
                if (word.toJson().values.isNotEmpty) {
                  bool? sure = await Get.dialog(
                    AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text(
                        "The translations you've added will be lost",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (!(sure ?? false)) return;
                }
                setState(() => words.remove(word));
              },
            ),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
          );
        },
      ),
    );
  }
}
