import 'dart:async';

import 'package:news_application/my_bloc/my_base_bloc.dart';


abstract class PrivateBloc<Event, State> extends MyBaseBloc<State> {
  final _eventController = StreamController<Event>();
  Stream<Event> get eventStream => _eventController.stream;

  PrivateBloc(super.state) {
    _eventController.stream.listen((event) {
      listener(event);
    });
  }

  void listener(Event event);
  void add(Event event) {
    _eventController.add(event);
  }

  @override
  void close() {
    _eventController.close();
  }
}
