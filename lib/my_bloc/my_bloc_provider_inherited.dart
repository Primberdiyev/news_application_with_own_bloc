import 'package:flutter/material.dart';

class MyBlocProviderInherited<B> extends InheritedWidget {
  const MyBlocProviderInherited({
    super.key,
    required super.child,
    required this.bloc,
  });

  final B bloc;

  static B read<B>(BuildContext context, {bool listen = false}) {
    if (listen) {
      final MyBlocProviderInherited<B>? widget = context
          .dependOnInheritedWidgetOfExactType<MyBlocProviderInherited<B>>();
      assert(widget != null, 'No MyBlocProviderInherited found in context');
      return widget!.bloc;
    } else {
      final MyBlocProviderInherited<B>? widget =
          context.findAncestorWidgetOfExactType<MyBlocProviderInherited<B>>();
      assert(widget != null, 'No MyBlocProviderInherited found in context');
      return widget!.bloc;
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
