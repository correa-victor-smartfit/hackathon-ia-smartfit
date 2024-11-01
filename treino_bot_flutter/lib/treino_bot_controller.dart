import 'package:flutter/material.dart';
import 'package:treino_bot_flutter/treino_bot_repository.dart';
import 'package:treino_bot_flutter/treino_bot_state.dart';

class TreinoBotController extends ValueNotifier<TreinoBotState> {
  TreinoBotController() : super(TreinoBotInitialState());

  Future<void> generateTraining() async {
    value = TreinoBotLoadingState();

    try {
      final result = await TreinoBotRepository.generateString();
      value = TreinoBotSuccessState(result: result);
    } catch (error) {
      value = TreinoBotErrorState(error: '$error');
    }
  }
}
