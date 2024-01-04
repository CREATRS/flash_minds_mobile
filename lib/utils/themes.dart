import 'package:flutter/material.dart';

import 'constants.dart';

ButtonStyle _buttonStyle({required bool dark}) {
  double opacity = dark ? .2 : .1;
  Color color = dark ? AppColors.red : AppColors.lightRed;
  Color textColor = dark ? Colors.white : Colors.black;
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    overlayColor: MaterialStateProperty.all<Color>(color.withOpacity(opacity)),
  );
}

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: AppColors.red,
  secondaryHeaderColor: AppColors.lightRed,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.purple,
    foregroundColor: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(dark: true)),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.red),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(AppColors.red),
    trackColor: MaterialStateProperty.all<Color>(Colors.black45),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.lightRed,
    indicatorColor: AppColors.lightRed,
  ),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(dark: true)),
);

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.lightRed,
  secondaryHeaderColor: AppColors.red,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.lightPurple,
    foregroundColor: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(dark: false)),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.lightRed),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(AppColors.lightRed),
    trackColor: MaterialStateProperty.all<Color>(Colors.grey.shade500),
    trackOutlineColor: MaterialStateProperty.all<Color>(Colors.grey.shade500),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.red,
    indicatorColor: AppColors.red,
  ),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(dark: false)),
);
