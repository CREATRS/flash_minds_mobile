import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/screens/authentication/authentication.dart';
import 'package:flash_minds/screens/home.dart';
import 'package:flash_minds/screens/select_word_pack.dart';
import 'package:flash_minds/utils/constants.dart';

Route<dynamic> router(RouteSettings settings) {
  late Widget screen;
  AuthService auth = Get.find<AuthService>();

  switch (settings.name) {
    // case Routes.game:
    //   Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
    //   screen = HangmanGame(
    //     wordPack: args[StorageKeys.wordPacks],
    //     progress: args['progress'],
    //   );
    //   break;
    case Routes.createWordpack:
      screen = const Home();
      break;
    case Routes.home:
      screen = const Home();
      break;
    case Routes.selectWordpack:
      screen = const SelectWordpack();
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  return MaterialPageRoute(
    builder: (_) => Obx(
      () => auth.isAuthenticated
          ? Scaffold(
              appBar: AppBar(),
              body: screen,
              drawer: drawer(auth),
            )
          : const Authentication(),
    ),
    settings: settings,
  );
}

Drawer drawer(AuthService auth) {
  User user = auth.user.value!;
  return Drawer(
    backgroundColor: Get.theme.scaffoldBackgroundColor,
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          otherAccountsPictures: [
            Icon(
              Icons.dark_mode_rounded,
              color: Get.theme.secondaryHeaderColor,
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
            color: Get.theme.primaryColor.withOpacity(1),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Get.theme.secondaryHeaderColor,
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
        const _RouteCard(text: 'Home', route: Routes.home, icon: Icons.home),
        const _RouteCard(
          text: 'Profile',
          route: Routes.profile,
          icon: Icons.person,
        ),
        // const _RouteCard(
        //   text: 'Store',
        //   route: Routes.store,
        //   icon: Icons.store,
        // ),
        // const _RouteCard(
        //   text: 'Leaderboard',
        //   route: Routes.leaderboard,
        //   icon: Icons.leaderboard,
        // ),
        // const _RouteCard(
        //   text: 'How to play',
        //   route: Routes.howToPlay,
        //   icon: Icons.help,
        // ),
        // const _RouteCard(
        //   text: 'About',
        //   route: Routes.about,
        //   icon: Icons.info,
        // ),
        const Spacer(flex: 2),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            await auth.logout();
            Get.offAllNamed(Routes.home);
          },
        ),
        const Spacer(),
      ],
    ),
  );
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.text,
    required this.route,
    required this.icon,
  });

  final String text;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    String currentRoute = Get.currentRoute;
    bool isCurrentRoute = currentRoute == route;
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: TextStyles.pMedium,
      ),
      onTap: () {
        if (isCurrentRoute) return;
        Get.offAllNamed(route);
      },
      selectedColor: isCurrentRoute ? Get.theme.primaryColor : null,
      selected: isCurrentRoute,
      tileColor: isCurrentRoute ? Colors.amber : null,
      selectedTileColor: isCurrentRoute ? Colors.grey.withOpacity(.1) : null,
    );
  }
}
