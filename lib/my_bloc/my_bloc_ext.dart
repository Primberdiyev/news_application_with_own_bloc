import 'package:flutter/material.dart';
import 'package:news_application/my_bloc/my_bloc_provider_inherited.dart';

extension BlocGetter on BuildContext {
  T getBloc<T>() {
    final provider =
        findAncestorWidgetOfExactType<MyBlocProviderInherited<T>>();
    assert(provider != null, 'MyBlocProviderInherited<$T> topilmadi');
    return provider!.bloc;
  }
}
