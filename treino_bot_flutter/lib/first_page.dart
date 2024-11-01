import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

  void retry() {
    controller.retry();
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
                  retry: retry,
                ),
              TreinoBotSuccessState(:final result) => _SuccessWidget(
                  result: result,
                  retry: retry,
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
    required this.retry,
  });

  final String errorText;
  final Function() retry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              errorText,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: retry,
            child: const Text('Voltar'),
          ),
        ),
      ],
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({
    required this.result,
    required this.retry,
  });

  final String result;
  final Function() retry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Markdown(data: result),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: retry,
            child: const Text('Voltar'),
          ),
        )
      ],
    );
  }
}
