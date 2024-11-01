import 'package:flutter/material.dart';
import 'package:treino_bot_flutter/treino_bot_controller.dart';
import 'package:treino_bot_flutter/treino_bot_state.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final controller = TreinoBotController();

  void loadTraining() {
    controller.generateTraining();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino Bot'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, child) {
            return switch (value) {
              TreinoBotInitialState() => _InitialWidget(
                  gerarTreino: loadTraining,
                ),
              TreinoBotLoadingState() => const _LoadingWidget(),
              TreinoBotErrorState(:final error) => _ErrorWidget(
                  errorText: error,
                ),
              TreinoBotSuccessState(:final result) => _SuccessWidget(
                  result: result,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _InitialWidget extends StatelessWidget {
  const _InitialWidget({
    required this.gerarTreino,
  });

  final Function() gerarTreino;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: gerarTreino,
        child: const Text('Gerar Treino'),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.errorText,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({
    required this.result,
  });

  final String result;

  @override
  Widget build(BuildContext context) {
    return Text(result);
  }
}
