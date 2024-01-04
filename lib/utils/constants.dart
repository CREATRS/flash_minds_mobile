import 'package:flutter/material.dart';

// Backend
// const String entitlementId = 'premium';

class Routes {
  static const String createWordpack = '/create_wordpack';
  // static const String game = '/game';
  static const String home = '/';
  static const String profile = '/profile';
  static const String selectWordpack = '/select_wordpack';
}

class StorageKeys {
  static const String box = 'flash_minds';
  static const String darkMode = 'dark_mode';
  static const String user = 'user';
  static const String wordPacks = 'word_packs';
}

class Urls {
  // TODO: Update URLs
  static const String privacyPolicy = 'https://macromedia.net/privacy-policy';
}

// Style
class AppColors {
  static const Color red = Color(0xFFA41623);
  static const Color lightPurple = Color(0xFF7678ED);
  static const Color lightRed = Color(0xFFEF6A69);
  static const Color purple = Color(0xFF3D348b);
}

const Curve curve = Curves.easeInOut;
const Duration duration = Duration(milliseconds: 300);

const InputDecoration inputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
);

class TextStyles {
  static const h1 = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);
  static const h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const h4 = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const pMedium = TextStyle(fontSize: 14);
}
