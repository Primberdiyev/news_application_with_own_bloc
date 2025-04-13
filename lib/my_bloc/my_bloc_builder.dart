import 'package:flutter/material.dart';
import 'package:news_application/my_bloc/my_base_bloc.dart';
import 'package:news_application/my_bloc/my_bloc_listener.dart';
import 'package:news_application/my_bloc/my_bloc_provider_inherited.dart';

class MyBlocBuilder<B extends MyBaseBloc<S>, S> extends StatefulWidget {
  const MyBlocBuilder({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  final Widget Function(BuildContext context, S state) builder;
  final bool Function(S previous, S current)? buildWhen;

  @override
  State<MyBlocBuilder<B, S>> createState() => _MyBlocBuilderState<B, S>();
}

class _MyBlocBuilderState<B extends MyBaseBloc<S>, S>
    extends State<MyBlocBuilder<B, S>> {
  late S _state;
  @override
  void initState() {
    super.initState();
    _state = MyBlocProviderInherited.read<B>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return MyBlocListener<B, S>(
      listener: (context, state) => setState(() => _state = state),
      listenWhen: widget.buildWhen,
      child: widget.builder(context, _state),
    );
  }
}
