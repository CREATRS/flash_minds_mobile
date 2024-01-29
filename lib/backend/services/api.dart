import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:flash_minds/backend/data/word_packs.dart';
import 'package:flash_minds/backend/models/object_response.dart';
import 'package:flash_minds/backend/models/review.dart';
import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/models/word.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/secrets.dart';
import 'package:flash_minds/utils/constants.dart';

enum _Method { post, patch, delete }

Dio dio = Dio(
  BaseOptions(
    baseUrl: host,
    validateStatus: (status) => status! < 500,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
  ),
);

class Api {
  // CRUD
  static Future<ObjectResponse<WordPack>> _crudWordPack(
    _Method method, {
    int? id,
    String? name,
    String? asset,
    List<Word>? words,
  }) async {
    Response? response;
    bool success = false;

    Map<String, dynamic> data = {
      'name': name,
      'asset': asset,
      'words': words?.map((w) => w.toJson()).toList(),
    };
    data.removeWhere((key, value) => value == null);

    if (method == _Method.post) {
      response = await dio.post('word_pack', data: data);
      success = response.statusCode == 201;
    } else if (method == _Method.patch) {
      assert(id != null);
      response = await dio.patch('word_pack/$id', data: data);
      success = response.statusCode == 200;
    } else if (method == _Method.delete) {
      assert(id != null);
      response = await dio.delete('word_pack/$id');
      return ObjectResponse(success: response.statusCode == 204);
    }
    return ObjectResponse(
      success: success,
      object: success ? WordPack.fromJson(response!.data) : null,
      errors: response == null
          ? ['Method not allowed']
          : response.data.runtimeType is String
              ? [response.data]
              : response.data['errors'],
    );
  }

  static Future<ObjectResponse<WordPack>> createWordPack({
    required String name,
    required String asset,
    required List<Word> words,
  }) async =>
      await _crudWordPack(
        _Method.post,
        name: name,
        asset: asset,
        words: words,
      );

  static Future<ObjectResponse<WordPack>> deleteWordPack(int id) async =>
      await _crudWordPack(_Method.delete, id: id);

  static Future<List<WordPack>> getWordPacks({bool me = false}) async {
    List<Map<String, dynamic>> data =
        me ? [] : List.from(StaticData.wordPacks.data!);
    Box box = Hive.box(StorageKeys.box);
    bool fetched = false;

    if (await _hasInternet()) {
      try {
        String query = me ? '?me=true' : '';
        Response webResponse = await dio.get('word_pack/?me=$query');
        if (webResponse.statusCode != 200) throw Exception();

        List<Map<String, dynamic>> wr =
            List<Map<String, dynamic>>.from(webResponse.data);
        data = wr + data;
        if (!me) {
          box.put(StorageKeys.wordPacks, jsonEncode(wr));
        }
        fetched = true;
      } on DioException catch (_) {
        fetched = false;
      } on Exception catch (_) {
        fetched = false;
      }
    }
    if (!fetched) {
      String? wordpacks = box.get(StorageKeys.wordPacks);
      if (wordpacks != null) {
        data += List<Map<String, dynamic>>.from(jsonDecode(wordpacks));
      }
    }

    return List<WordPack>.from(
      data.map((wordpack) => WordPack.fromJson(wordpack)),
    );
  }

  static Future<List<WordPack>> getWordPacksById(List<int> ids) async {
    List<Map<String, dynamic>> data = List.from(StaticData.wordPacks.data!);
    data.retainWhere((w) => ids.contains(w['id']));

    Response webResponse = await dio.get('word_pack/?ids=${ids.join(",")}');
    if (webResponse.statusCode != 200) throw Exception();

    List<Map<String, dynamic>> wr =
        List<Map<String, dynamic>>.from(webResponse.data);
    data = wr + data;
    data.sort((a, b) => ids.indexOf(a['id']));
    return List<WordPack>.from(
      data.map((wordpack) => WordPack.fromJson(wordpack)),
    );
  }

  static Future<ObjectResponse<WordPack>> updateWordPack(
    int id, {
    String? name,
    String? asset,
    List<Word>? words,
  }) async =>
      await _crudWordPack(
        _Method.patch,
        id: id,
        name: name,
        asset: asset,
        words: words,
      );

  // Other
  static Future<Review?> getPreviousReview(int wordPackId) async {
    Response response = await dio.get('word_pack/$wordPackId/rate/');
    return response.statusCode == 200 ? Review.fromJson(response.data) : null;
  }

  static Future<bool> rateWordPack(int id, {required int rating}) async {
    Response response = await dio.post(
      'word_pack/$id/rate/',
      data: {'rating': rating},
    );
    return response.statusCode == 200;
  }

  static Future<List<UserProgress>> trackWordPack(
    int id, {
    List<int> steps = const [],
  }) async {
    Response response = await dio.post(
      'word_pack/$id/track/',
      data: {'progress': steps},
    );
    return List<UserProgress>.from(
      List<Map<String, dynamic>>.from(response.data['values']).map(
        (progress) => UserProgress.fromJson(progress),
      ),
    );
  }
}

Future<bool> _hasInternet() async {
  try {
    List result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
