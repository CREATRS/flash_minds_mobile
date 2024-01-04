import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/app_icon.dart';
import 'package:flash_minds/widgets/components/button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RoundedLoadingButtonController playController =
      RoundedLoadingButtonController();
  bool showPrivacyPolicyButton = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthService>(
      builder: (appstate) {
        User user = appstate.user.value!;
        return Column(
          children: [
            const Spacer(flex: 2),
            const Text('Flash⚡️Minds', style: TextStyles.h1),
            const AppIcon(),
            const Spacer(),
            if (user.hasLanguages)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/flags/${user.sourceLanguage}.png',
                      width: 48,
                    ),
                    IconButton(
                      icon: const Icon(Icons.compare_arrows_rounded),
                      onPressed: () async {
                        await Get.bottomSheet(const _SelectLanguages());
                        setState(() {});
                      },
                    ),
                    Image.asset(
                      'assets/flags/${user.targetLanguage}.png',
                      width: 48,
                    ),
                  ],
                ),
              ),
            Button(
              text: "Let's play!",
              controller: playController,
              onPressed: () async {
                playController.start();
                if (!user.hasLanguages) {
                  await 300.milliseconds.delay(
                        () async =>
                            await Get.bottomSheet(const _SelectLanguages()),
                      );
                }
                if (!user.hasLanguages) {
                  playController.error();
                  300.milliseconds.delay(() => playController.reset());
                  return;
                }
                setState(() {});
                playController.success();
                await 1
                    .seconds
                    .delay(() => Get.toNamed(Routes.selectWordpack));
                playController.reset();
              },
            ),
            const SizedBox(height: 12),
            const Button(text: 'Profile', width: 250, onPressed: null),
            const Spacer(flex: 2),
          ],
        );
      },
    );
  }
}

class _SelectLanguages extends StatefulWidget {
  const _SelectLanguages();

  @override
  State<_SelectLanguages> createState() => __SelectLanguagesState();
}

class __SelectLanguagesState extends State<_SelectLanguages> {
  String? sourceLanguage;
  String? targetLanguage;

  Widget languageButton(Language language, bool isSource) {
    bool isActive = isSource && sourceLanguage == language.code ||
        !isSource && targetLanguage == language.code;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSource
              ? sourceLanguage = language.code
              : targetLanguage = language.code;
        });
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(
          border: isActive
              ? Border.all(color: Theme.of(context).primaryColor)
              : null,
          borderRadius: BorderRadius.circular(32),
        ),
        width: isActive ? 64 : 48,
        duration: const Duration(milliseconds: 200),
        child:
            Image.asset('assets/flags/${language.code}.png', fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthService>(
      builder: (auth) {
        sourceLanguage ??= auth.user.value?.sourceLanguage;
        targetLanguage ??= auth.user.value?.targetLanguage;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text('Select your languages', style: TextStyles.h3),
              ),
              const SizedBox(height: 16),
              const Text('Native language'),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Languages.values
                      .map((language) => languageButton(language, true))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Target language'),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Languages.values
                      .map((language) => languageButton(language, false))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<AuthService>(
                builder: (auth) {
                  return Button(
                    onPressed: () async {
                      await auth.updateUser(
                        sourceLanguage: sourceLanguage,
                        targetLanguage: targetLanguage,
                      );
                      Get.back();
                    },
                    text: 'Save',
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
