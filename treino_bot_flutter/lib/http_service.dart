import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

class HttpService {
  static Future<String> generateTraining({
    required String url,
  }) async {
    final dio = Dio();

    try {
      final result = await dio.get(
        url,
      );

      final data = result.data as String;
      return data;
    } catch (error) {
      log('$error', name: 'Http error');
      rethrow;
    }
  }
}
