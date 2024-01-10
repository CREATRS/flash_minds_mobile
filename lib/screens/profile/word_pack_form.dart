import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/object_response.dart';
import 'package:flash_minds/backend/models/word.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/utils/validators.dart';
import 'package:flash_minds/widgets/components/button.dart';

class WordPackForm extends StatefulWidget {
  const WordPackForm({super.key, this.wordPack});
  final WordPack? wordPack;

  @override
  State<WordPackForm> createState() => _WordPackFormState();
}

class _WordPackFormState extends State<WordPackForm> {
  bool addingWord = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Language> selectedLanguages = [];
  List<Word> words = [];
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  String errors = '';
  TextEditingController nameController = TextEditingController(),
      wordController = TextEditingController();
  FocusNode wordFocus = FocusNode();
  Map wordPointer = {};

  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.wordPack != null;
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
              const SizedBox(height: 32),
              TextFormField(
                controller: nameController,
                initialValue: widget.wordPack?.name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => requiredValidator(value),
              ),
              const SizedBox(height: 16),
              const Text('Languages', style: TextStyles.h3),
              Row(
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
                        onTap: () {
                          setState(() {
                            if (selectedLanguages.contains(e)) {
                              selectedLanguages.remove(e);
                            } else {
                              List<String> codes = Languages.values
                                  .map((l) => l.code)
                                  .toList(growable: false);
                              selectedLanguages.add(e);
                              selectedLanguages.sort(
                                (a, b) => codes
                                    .indexOf(a.code)
                                    .compareTo(codes.indexOf(b.code)),
                              );
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('Words', style: TextStyles.h3),
              SizedBox(
                height: min(
                  60 + (words.length * 71).toDouble(),
                  MediaQuery.of(context).size.height * .35,
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
                        onTap: () => setState(() => words.insert(0, Word())),
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
                                width: 100,
                                margin: const EdgeInsets.only(right: 8),
                                child: wordPointer['word'] == pointer['word'] &&
                                        wordPointer['lang'] == pointer['lang']
                                    ? TextField(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                        ),
                                        focusNode: wordFocus,
                                        controller: wordController,
                                        onTapOutside: (event) {
                                          if (wordController.text.isNotEmpty) {
                                            word.set(
                                              l.code,
                                              wordController.text,
                                            );
                                            wordController.clear();
                                          }
                                          setState(() => wordPointer = {});
                                        },
                                      )
                                    : InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          wordFocus.requestFocus();
                                          wordController.text = value ?? '';
                                          setState(
                                            () => wordPointer = pointer,
                                          );
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
                        onPressed: () => setState(() => words.remove(word)),
                      ),
                    );
                  },
                ),
              ),
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
                    late ObjectResponse response;
                    buttonController.start();
                    if (isEdit) {
                      response = await Api.updateWordPack(
                        widget.wordPack!.id,
                        name: nameController.text,
                      );
                    } else {
                      response = await Api.createWordPack(
                        name: nameController.text,
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
                        () => Navigator.pop(context),
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
}
