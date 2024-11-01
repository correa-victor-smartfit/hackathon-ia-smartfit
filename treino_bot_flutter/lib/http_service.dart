import 'package:dio/dio.dart';

class HttpService {
  static Future<String> generateTraining({
    required String url,
  }) async {
    final dio = Dio();

    final result = dio.post(
      url,
    );

    return '';
  }
}
