import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:flash_minds/backend/data/word_packs.dart';
import 'package:flash_minds/backend/models/object_response.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/secrets.dart';
import 'package:flash_minds/utils/constants.dart';

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
  static Future<ObjectResponse<WordPack>> createWordPack({
    required String name,
  }) async {
    Response response = await dio.post(
      'word_pack',
      data: {'name': name},
    );
    bool success = response.statusCode == 200;

    return ObjectResponse(
      success: success,
      object: success ? WordPack.fromJson(response.data) : null,
      errors: response.data['errors'],
    );
  }

  static Future<List<WordPack>> getWordPacks({bool me = false}) async {
    List<Map<String, dynamic>> data = me ? [] : StaticData.wordPacks.data!;
    Box box = Hive.box(StorageKeys.box);
    bool fetched = false;

    if (await _hasInternet()) {
      try {
        Response webResponse = await dio.get('word_pack');
        List<Map<String, dynamic>> wr =
            List<Map<String, dynamic>>.from(webResponse.data);
        data = wr + data;
        box.put(StorageKeys.wordPacks, jsonEncode(wr));
        fetched = true;
      } on DioException catch (_) {
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

  static Future<ObjectResponse<WordPack>> updateWordPack(
    int id, {
    String? name,
  }) async {
    Map<String, dynamic> wordPack = {
      'name': name,
    };
    wordPack.removeWhere((key, value) => value == null);

    Response response = await dio.put('word_packs/$id', data: wordPack);
    bool success = response.statusCode == 200;

    return ObjectResponse(
      success: success,
      object: success ? WordPack.fromJson(response.data) : null,
      errors: response.data['errors'],
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
