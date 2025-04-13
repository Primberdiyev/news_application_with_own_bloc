import 'package:flutter/material.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:news_application/my_bloc/private_bloc.dart';

part 'tesla_news_event.dart';
part 'tesla_news_state.dart';

class TeslaNewsBloc extends PrivateBloc<TeslaNewsEvent, TeslaNewsState> {
  TeslaNewsBloc() : super(TeslaNewsInitial());

  @override
  void listener(TeslaNewsEvent event) {
    switch (event) {
      case DeleteteslaNewsByIdEvent _:
        deleteNewsById(event);
        break;
      case EditNewsEvent _:
        editNews(event);
        break;
      case GetTeslaNewEvent _:
        getTeslaNews(event);
        break;
      case RefleshNewsEvent _:
        refleshNews(event);
        break;

      case FilterTeslaNewsEvent _:
        filterNews(event);
    }
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();

  void deleteNewsById(
    DeleteteslaNewsByIdEvent event,
  ) async {
    databaseService.deleteNewsById(id: event.article.id);
    if (state is TeslaNewsSucessState) {
      final currentState = state as TeslaNewsSucessState;
      final news = currentState.articles;
      news.remove(event.article);
      emit(TeslaNewsSucessState(articles: news));
    }
  }

  void editNews(
    EditNewsEvent event,
  ) async {
    await databaseService.editNews(article: event.editedArticle);
    if (state is TeslaNewsSucessState) {
      final currentState = state as TeslaNewsSucessState;
      final news = currentState.articles;
      news[news.indexOf(event.lastArticle)] = event.editedArticle;
      emit(TeslaNewsSucessState(articles: news));
    }
  }

  void getTeslaNews(
    GetTeslaNewEvent event,
  ) async {
    emit(TeslaNewsLoadingState());

    try {
      final news = await newsRepositories.setAndGetNews(isTesla: true);

      emit(TeslaNewsSucessState(articles: news, originalArticles: news));
    } catch (e) {
      debugPrint('error on getting news by query $e');
      emit(TeslaNewsErrorState(errorMessage: e.toString()));
    }
  }

  void refleshNews(
    RefleshNewsEvent event,
  ) async {
    if (state is TeslaNewsSucessState) {
      await databaseService.clearDatabase();
      add(GetTeslaNewEvent());
    }
  }

  void filterNews(
    FilterTeslaNewsEvent event,
  ) {
    if (state is TeslaNewsSucessState) {
      final currentState = state as TeslaNewsSucessState;
      final news = currentState.originalArticles;

      final filteredNews = (news ?? [])
          .where((element) => (element.title ?? '')
              .toLowerCase()
              .contains(event.enteredWord.toLowerCase()))
          .toList();
      emit(currentState.copyWith(articles: filteredNews));
    }
  }
}
