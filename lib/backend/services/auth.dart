import 'dart:developer';

import 'package:dio/dio.dart' show DioException, Response;
import 'package:get/get.dart' hide Response;

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/utils/constants.dart';
import 'api.dart';

class AuthService extends GetxController {
  Future<void> init(AppStateService appState) async {
    _appState = appState;
    await _loadUser();
  }

  late AppStateService _appState;
  Rxn<User> user = Rxn<User>();
  String? purchasesUserId;
  RxBool entitlementIsActive = false.obs;

  Future<void> _loadUser() async {
    Map? userData = _appState.box.get(StorageKeys.user);
    if (userData != null) {
      try {
        dio.options.headers['Authorization'] = 'Token ${userData['token']}';
        Response response = await dio.get('account/');
        if (response.statusCode == 200) {
          user.value = User.fromJson(
            Map<String, dynamic>.from(
              {
                ...response.data,
                'token': userData['token'],
              },
            ),
          );
          await _saveUser();
        } else {
          _appState.box.delete(StorageKeys.user);
          userData = null;
        }
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
    try {
      await dio.post('auth/logout/');
    } on DioException catch (e) {
      log('Error logging out: $e');
    }
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
      return response.data['error'] ?? response.data['errors'][0]['message'];
    }
  }

  Future<void> updateUser({
    String? name,
    String? email,
    String? avatar,
    String? sourceLanguage,
    String? targetLanguage,
    List<UserProgress>? progress,
    bool updateOnServer = true,
  }) async {
    var data = {
      'name': name,
      'email': email,
      'avatar': avatar,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'progress': progress?.map((progress) => progress.toJson()).toList(),
    };
    data.removeWhere((_, value) => value == null);
    if (updateOnServer) {
      var updatedUser =
          await dio.patch('account/${user.value!.id}/', data: data);
      user.value =
          User.fromJson({...updatedUser.data, 'token': user.value!.token});
    } else {
      user.value = user.value!.copyWith(
        name: name,
        email: email,
        avatar: avatar,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        progress: progress,
      );
    }
    await _saveUser();
    update();
  }
}
