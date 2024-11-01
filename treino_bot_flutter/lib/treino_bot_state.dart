sealed class TreinoBotState {}

class TreinoBotInitialState extends TreinoBotState {}

class TreinoBotLoadingState extends TreinoBotState {}

class TreinoBotErrorState extends TreinoBotState {
  final String error;

  TreinoBotErrorState({required this.error});
}

class TreinoBotSuccessState extends TreinoBotState {
  final String result;

  TreinoBotSuccessState({required this.result});
}
