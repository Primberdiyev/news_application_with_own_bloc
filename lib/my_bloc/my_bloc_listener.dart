import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_application/my_bloc/my_base_bloc.dart';
import 'package:news_application/my_bloc/my_bloc_provider_inherited.dart';

class MyBlocListener<B extends MyBaseBloc<S>, S> extends StatefulWidget {
  const MyBlocListener({
    super.key,
    required this.listener,
    required this.child,
    this.listenWhen,
  });

  final Widget child;
  final void Function(BuildContext context, S state) listener;
  final bool Function(S previous, S current)? listenWhen;

  @override
  State<MyBlocListener<B, S>> createState() => _MyBlocListenerState<B, S>();
}

class _MyBlocListenerState<B extends MyBaseBloc<S>, S>
    extends State<MyBlocListener<B, S>> {
  late final StreamSubscription<S> _subscription;
  late S _lastState;

  @override
  void initState() {
    super.initState();
    final bloc = MyBlocProviderInherited.read<B>(context);
    _lastState = bloc.state;
    _subscription = bloc.stateStream.listen(listener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void listener(S state) {
    bool isUpdate = true;
    if (widget.listenWhen != null) {
      isUpdate = widget.listenWhen?.call(_lastState, state) ?? true;
    }
    if (isUpdate) {
      widget.listener(context, state);
    }
    _lastState = state;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
