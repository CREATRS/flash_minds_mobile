import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/screens/authentication/authentication.dart';
import 'package:flash_minds/screens/flash_cards/flash_cards.dart';
import 'package:flash_minds/screens/flash_cards/results_screen.dart';
import 'package:flash_minds/screens/home.dart';
import 'package:flash_minds/screens/profile/profile.dart';
import 'package:flash_minds/screens/select_word_pack.dart';
import 'package:flash_minds/utils/constants.dart';

Route<dynamic> router(RouteSettings settings) {
  late Widget screen;
  AuthService auth = Get.find<AuthService>();
  bool hasOwnAppBar = false;

  switch (settings.name) {
    case Routes.flashCards:
      screen = FlashCards(settings.arguments as WordPack);
      hasOwnAppBar = true;
      break;
    case Routes.flashCardsCompleted:
      Map<String, int> args = settings.arguments as Map<String, int>;
      screen = ResultsScreen(
        correct: args['correct']!,
        incorrect: args['incorrect']!,
        wordPackId: args['word_pack_id']!,
      );
      hasOwnAppBar = true;
      break;
    case Routes.flashCardsStep1:
      screen = Step1(
        selectedWordPack: settings.arguments as WordPack,
        sourceLanguage: auth.user.value!.sourceLanguage!,
        targetLanguage: auth.user.value!.targetLanguage!,
      );
      hasOwnAppBar = true;
      break;
    case Routes.flashCardsStep2:
      screen = Step2(
        selectedWordPack: settings.arguments as WordPack,
        sourceLanguage: auth.user.value!.sourceLanguage!,
        targetLanguage: auth.user.value!.targetLanguage!,
      );
      hasOwnAppBar = true;
      break;
    case Routes.flashCardsStep3:
      screen = Step3(
        selectedWordPack: settings.arguments as WordPack,
        sourceLanguage: auth.user.value!.sourceLanguage!,
        targetLanguage: auth.user.value!.targetLanguage!,
      );
      hasOwnAppBar = true;
      break;
    case Routes.flashCardsStep4:
      Map<String, Object> args = settings.arguments as Map<String, Object>;
      screen = Step4(
        selectedWordPack: args['word_pack'] as WordPack,
        sourceLanguage: auth.user.value!.sourceLanguage!,
        targetLanguage: auth.user.value!.targetLanguage!,
        replay: args['replay'] as void Function(),
      );
      hasOwnAppBar = true;
      break;
    case Routes.home:
      screen = const Home();
      break;
    case Routes.profile:
      screen = const Profile();
      hasOwnAppBar = true;
      break;
    case Routes.selectWordpack:
      screen = const SelectWordpack();
      hasOwnAppBar = true;
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  return MaterialPageRoute(
    builder: (_) => Obx(
      () => auth.isAuthenticated
          ? Scaffold(
              appBar: hasOwnAppBar ? null : AppBar(),
              body: screen,
              drawer: const _Drawer(),
              resizeToAvoidBottomInset: false,
            )
          : const Authentication(),
    ),
    settings: settings,
  );
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    AuthService auth = Get.find<AuthService>();
    User user = auth.user.value!;
    ThemeData theme = Theme.of(context);

    Widget routeCard(String text, String route, IconData icon) {
      String currentRoute = Get.currentRoute;
      bool isCurrentRoute = currentRoute == route;
      return ListTile(
        leading: Icon(icon),
        title: Text(text, style: TextStyles.pMedium),
        onTap: () {
          if (isCurrentRoute) return;
          Get.offAllNamed(route);
        },
        selectedColor: isCurrentRoute ? theme.secondaryHeaderColor : null,
        selected: isCurrentRoute,
        selectedTileColor: isCurrentRoute ? Colors.grey.withOpacity(.1) : null,
      );
    }

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            otherAccountsPictures: [
              Stack(
                children: [
                  if (user.targetLanguage != null)
                    Positioned(
                      left: 12,
                      child: user.targetLanguage!.image(width: 24),
                    ),
                  if (user.sourceLanguage != null)
                    Positioned(
                      top: 4,
                      child: user.sourceLanguage!.image(width: 24),
                    ),
                ],
              ),
              Icon(
                Icons.dark_mode_rounded,
                color: theme.secondaryHeaderColor,
              ),
              GetBuilder<AppStateService>(
                builder: (appState) => Switch(
                  value: appState.darkMode.value,
                  onChanged: (bool value) => appState.setDarkMode(value),
                ),
              ),
            ],
            onDetailsPressed: () => Get.toNamed(Routes.profile),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(1),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.secondaryHeaderColor,
              foregroundImage: user.avatar == null
                  ? null
                  : Image.network(user.avatar!, fit: BoxFit.cover).image,
              child: user.avatar == null
                  ? Text(
                      user.name[0],
                      style: TextStyles.h1.copyWith(color: Colors.white),
                    )
                  : null,
            ),
            accountName: Text(
              user.name,
              style: TextStyles.h2.copyWith(
                shadows: [const Shadow(offset: Offset(0, 2), blurRadius: 2)],
              ),
            ),
            accountEmail: Text(
              user.email,
              style: TextStyles.pMedium.copyWith(
                color: Colors.white,
                shadows: [const Shadow(offset: Offset(0, 2), blurRadius: 2)],
              ),
            ),
          ),
          routeCard('Home', Routes.home, Icons.home),
          routeCard('Profile', Routes.profile, Icons.person),
          const Spacer(flex: 2),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => auth.logout(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
