import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

class HttpService {
  static Future<String> generateTraining({
    required String url,
  }) async {
    final dio = Dio();

    try {
      // final result = await dio.get(
      //   url,
      // );

      // final Map<String, dynamic> data = jsonDecode(result.data);
      // final treino = data['treino'];
      // return treino;

      await Future.delayed(const Duration(milliseconds: 1200));
      return '# Plano de Treino para Ganho de Massa Muscular - Iniciante\n\n### Treino A - Segunda-feira\n\n1. **Agachamento Smith Sumô** - 4 séries de 12 repetições\n2. **Remada Máquina Neutra** - 4 séries de 12 repetições\n3. **Crucifixo Halteres Inclinado** - 3 séries de 15 repetições\n\n### Treino B - Quarta-feira\n\n1. **Leg Press 45** - 4 séries de 12 repetições\n2. **Puxada Máquina** - 4 séries de 12 repetições\n3. **Rosca Direta Halter** - 3 séries de 15 repetições\n\n### Treino C - Sexta-feira\n\n1. **Supino Máquina** - 4 séries de 12 repetições\n2. **Tríceps Máquina Bilateral** - 4 séries de 12 repetições\n3. **Abdominal Máquina** - 3 séries de 15 repetições\n\nLembrando que é importante manter uma alimentação adequada, descanso suficiente e realizar os exercícios com a postura correta para obter os melhores resultados.';
    } catch (error) {
      rethrow;
    }
  }
}
