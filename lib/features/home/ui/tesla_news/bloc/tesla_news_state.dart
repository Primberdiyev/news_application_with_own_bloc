part of 'tesla_news_bloc.dart';

@immutable
abstract class TeslaNewsState {}

class TeslaNewsInitial extends TeslaNewsState {}

class TeslaNewsLoadingState extends TeslaNewsState {}

class TeslaNewsSucessState extends TeslaNewsState {
  final List<Article> articles;
  final List<Article>? originalArticles;
  TeslaNewsSucessState({required this.articles, this.originalArticles});

  TeslaNewsSucessState copyWith({
    List<Article>? articles,
    List<Article>? originalArticles,
  }) {
    return TeslaNewsSucessState(
      articles: articles ?? this.articles,
      originalArticles: originalArticles ?? this.originalArticles,
    );
  }
}

class TeslaNewsErrorState extends TeslaNewsState {
  final String errorMessage;
  TeslaNewsErrorState({required this.errorMessage});
}
