import 'package:treino_bot_flutter/http_service.dart';

class TreinoBotRepository {
  static Future<String> generateString() async {
    final result = await HttpService.generateTraining(
      url: 'http://10.0.2.2:3000/',
    );

    return result;
  }
}
