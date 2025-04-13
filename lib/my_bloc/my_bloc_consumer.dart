import 'package:flutter/material.dart';
import 'package:news_application/my_bloc/my_base_bloc.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';
import 'package:news_application/my_bloc/my_bloc_listener.dart';


class MyBlocConsumer<B extends MyBaseBloc<S>, S> extends StatefulWidget {
  const MyBlocConsumer({
    super.key,
    required this.builder,
    required this.listener,
    this.listenWhen,
    this.buildWhen,
  });
  final Widget Function(BuildContext context, S state) builder;
  final bool Function(S previous, S current)? buildWhen;
  final void Function(BuildContext context, S state) listener;
  final bool Function(S previous, S current)? listenWhen;

  @override
  State<MyBlocConsumer<B, S>> createState() => _MyBlocConsumerState<B, S>();
}

class _MyBlocConsumerState<B extends MyBaseBloc<S>, S>
    extends State<MyBlocConsumer<B, S>> {
  @override
  Widget build(BuildContext context) {
    return MyBlocListener<B, S>(
      listener: widget.listener,
      listenWhen: widget.listenWhen,
      child: MyBlocBuilder<B, S>(
        builder: widget.builder,
        buildWhen: widget.buildWhen,
      ),
    );
  }
}
