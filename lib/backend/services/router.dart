import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/screens/authentication/authentication.dart';
import 'package:flash_minds/screens/home.dart';
import 'package:flash_minds/screens/profile/profile.dart';
import 'package:flash_minds/screens/select_word_pack.dart';
import 'package:flash_minds/utils/constants.dart';

Route<dynamic> router(RouteSettings settings) {
  late Widget screen;
  AuthService auth = Get.find<AuthService>();
  bool hasOwnAppBar = false;

  switch (settings.name) {
    // case Routes.game:
    //   Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
    //   screen = HangmanGame(
    //     wordPack: args[StorageKeys.wordPacks],
    //     progress: args['progress'],
    //   );
    //   break;
    case Routes.home:
      screen = const Home();
      break;
    case Routes.profile:
      screen = const Profile();
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
