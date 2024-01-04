import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:flash_minds/backend/data/word_packs.dart';
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
  static Future<List<WordPack>> getWordPacks({bool me = false}) async {
    List<Map<String, dynamic>> data = StaticData.wordPacks.data!;
    Box box = Hive.box(StorageKeys.box);
    bool fetched = false;

    if (await _hasInternet()) {
      try {
        Response webResponse = await dio.get('word_packs');
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
