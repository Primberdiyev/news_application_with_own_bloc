import 'package:flutter/widgets.dart';
import 'package:news_application/my_bloc/my_bloc_provider_inherited.dart';

class MyBlocProvider<T> extends StatefulWidget {
  final T Function() create;
  final Widget child;

  const MyBlocProvider({
    required this.create,
    required this.child,
    super.key,
  });

  @override
  State<MyBlocProvider<T>> createState() => _MyBlocProviderState<T>();
}

class _MyBlocProviderState<B> extends State<MyBlocProvider<B>> {
  late final B _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return MyBlocProviderInherited<B>(
      bloc: _bloc,
      child: widget.child,
    );
  }
}
