import 'package:flutter/cupertino.dart';
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
  cupertinoOverrideTheme: const CupertinoThemeData(primaryColor: AppColors.red),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    errorStyle: TextStyle(color: AppColors.red),
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    prefixIconColor: AppColors.grey,
    suffixIconColor: AppColors.grey,
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.red)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.grey),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  primaryColor: AppColors.red,
  secondaryHeaderColor: AppColors.lightRed,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.red,
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
    labelColor: AppColors.red,
    indicatorColor: AppColors.red,
  ),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(dark: true)),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.red,
    selectionColor: AppColors.red.withOpacity(.5),
    selectionHandleColor: AppColors.red,
  ),
);

ThemeData lightTheme = ThemeData(
  cupertinoOverrideTheme:
      const CupertinoThemeData(primaryColor: AppColors.lightRed),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.black),
    errorStyle: TextStyle(color: AppColors.lightRed),
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    prefixIconColor: AppColors.grey,
    suffixIconColor: AppColors.grey,
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.lightRed)),
    focusedBorder: OutlineInputBorder(),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  ),
  primaryColor: AppColors.lightRed,
  secondaryHeaderColor: AppColors.red,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.lightRed,
    foregroundColor: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(dark: false)),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.lightRed),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(AppColors.lightRed),
    trackColor: MaterialStateProperty.all<Color>(AppColors.grey),
    trackOutlineColor: MaterialStateProperty.all<Color>(AppColors.grey),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.lightRed,
    indicatorColor: AppColors.lightRed,
  ),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(dark: false)),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.lightRed,
    selectionColor: AppColors.lightRed.withOpacity(.5),
    selectionHandleColor: AppColors.lightRed,
  ),
);
