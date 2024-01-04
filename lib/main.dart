import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/services/auth.dart';
import 'backend/services/app_state.dart';
import 'backend/services/router.dart';
import 'utils/themes.dart';

void main() async {
  Get.isLogEnable = false;
  AppStateService appState = AppStateService();
  await appState.init();
  Get.put(appState);
  Get.put(AuthService(appState));

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<AppStateService>(
        builder: (appState) => GetMaterialApp(
          title: 'FlashMinds',
          debugShowCheckedModeBanner: false,
          enableLog: false,
          onGenerateRoute: router,
          theme: appState.darkMode.value ? darkTheme : lightTheme,
        ),
      );
}
