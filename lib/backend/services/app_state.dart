import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flash_minds/utils/constants.dart';

class AppStateService extends GetxController {
  // Init state
  Future<void> init() async {
    await _loadStorage();
    setDarkMode(box.get(StorageKeys.darkMode));
  }

  // Values
  RxBool darkMode = false.obs;

  late Box box;

  // Methods
  Future<void> _loadStorage() async {
    await Hive.initFlutter();
    box = await Hive.openBox(StorageKeys.box);
  }

  Future<void> setDarkMode(bool? value) async {
    if (value == null) return;

    darkMode.value = value;
    await box.put(StorageKeys.darkMode, value);
    update();
  }
}
