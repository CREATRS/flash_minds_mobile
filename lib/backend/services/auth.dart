import 'dart:developer';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/utils/constants.dart';
import 'api.dart';

class AuthService extends GetxController {
  AuthService(AppStateService appState) {
    _appState = appState;
    _loadUser();
  }

  late AppStateService _appState;
  Rxn<User> user = Rxn<User>();
  String? purchasesUserId;
  RxBool entitlementIsActive = false.obs;

  void _loadUser() {
    Map? userData = _appState.box.get(StorageKeys.user);
    if (userData != null) {
      try {
        user.value = User.fromJson(Map<String, dynamic>.from(userData));
        dio.options.headers['Authorization'] = 'Token ${userData['token']}';
        update();
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        log('Error loading user: $e');
        _appState.box.delete(StorageKeys.user);
        user.value = null;
      }
    }
  }

  Future<void> _saveUser() async {
    dio.options.headers['Authorization'] = 'Token ${user.value!.token}';
    await _appState.box.put('user', user.value!.toJson());
  }

  bool get isAuthenticated => user.value != null;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    var response = await dio.post(
      'auth/login/',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      user.value = User.fromJson(response.data);
      await _saveUser();
      return null;
    } else {
      return response.data['error'];
    }
  }

  Future<bool> logout() async {
    await dio.post('auth/logout/');
    dio.options.headers.remove('Authorization');
    user.value = null;
    await _appState.box.delete(StorageKeys.user);
    return true;
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    var response = await dio.post(
      'auth/register/',
      data: {'name': name, 'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      user.value = User.fromJson(response.data);
      await _saveUser();
      return null;
    } else {
      return response.data['error'];
    }
  }

  Future<void> updateUser({
    String? name,
    String? email,
    String? avatar,
    String? sourceLanguage,
    String? targetLanguage,
  }) async {
    var data = {
      'name': name,
      'email': email,
      'avatar': avatar,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
    };
    data.removeWhere((_, value) => value == null);
    var updatedUser =
        await dio.patch('accounts/${user.value!.id}/', data: data);
    user.value = User.fromJson(updatedUser.data);
    await _saveUser();
    update();
  }
}
