import 'dart:async';

abstract class MyBaseBloc<State> {
  MyBaseBloc(this.state) {
    _stateController.add(state);
  }
  final _stateController = StreamController<State>.broadcast();
  Stream<State> get stateStream => _stateController.stream;
  State state;

  void emit(State value) {
    state = value;
    _stateController.add(value);
  }

  void close() {
    _stateController.close();
  }
}
