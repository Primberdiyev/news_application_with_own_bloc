import 'dart:developer';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/home/bloc/home_state.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:news_application/features/utils/sort_components.dart';
import 'package:news_application/my_bloc/private_bloc.dart';

class HomeBloc extends PrivateBloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  void listener(HomeEvent event) {
    switch (event) {
      case DeleteNewsByIdEvent():
        deleteNewsById(event);
        break;

      case EditNewsEvent():
        editNews(
          event,
        );
        break;

      case RefleshNewsEvent():
        refleshNews(
          event,
        );
        break;

      case PickImageEvent():
        pickImage(
          event,
        );
        break;

      case CreateNewArticle():
        createNewArticle(
          event,
        );
        break;

      case ChangeCategoryEvent():
        changeCategory(
          event,
        );
        break;

      case ChangeSlideIndexEvent():
        changeSliderIndex(
          event,
        );
        break;

      case GetTeslaNewEvent():
        getTeslaNews(
          event,
        );
        break;

      case FilterNewsEvent():
        filterNews(
          event,
        );
        break;
    }
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final defaultCountry = SortComponents.countryComponents.first;
  final defaultCategory = SortComponents.categories.first;
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

  void deleteNewsById(
    DeleteNewsByIdEvent event,
  ) async {
    databaseService.deleteNewsById(id: event.article.id);
    if (state is HomeSuccessState) {
      final currentState = state as HomeSuccessState;
      final news = currentState.articles;
      news.remove(event.article);
      emit(currentState.copyWith(articles: news));
    }
  }

  void editNews(
    EditNewsEvent event,
  ) async {
    await databaseService.editNews(article: event.editedArticle);
    if (state is HomeSuccessState) {
      final currentState = state as HomeSuccessState;
      final news = currentState.articles;
      news[news.indexOf(event.lastArticle)] = event.editedArticle;
      emit(currentState.copyWith(articles: news));
    }
  }

  void refleshNews(
    RefleshNewsEvent event,
  ) async {
    if (state is HomeSuccessState) {
      await databaseService.clearDatabase();
      add(GetTeslaNewEvent());
    }
  }

  void pickImage(PickImageEvent event) async {
    final currentState = state;
    emit(HomeLoadingState());
    final imageLink = await newsRepositories.getImageLink();
    if (imageLink.isEmpty) {
      emit(currentState);
      return;
    }
    if (currentState is HomeSuccessState) {
      emit(currentState.copyWith(pickedImageLink: imageLink));
    }
  }

  void createNewArticle(
    CreateNewArticle event,
  ) async {
    final successState = state as HomeSuccessState;
    emit(HomeLoadingState());
    try {
      await databaseService.createArticle(event.createdArticle);
      emit(successState.copyWith(selectedCategory: event.selectedCategory));
    } catch (e) {
      log('error on creating article $e');
      emit(HomeErrorState(errorMessage: e.toString()));
    }
  }

  void changeCategory(
    ChangeCategoryEvent event,
  ) {
    if (state is HomeSuccessState) {
      final currentstate = state as HomeSuccessState;
      emit(currentstate.copyWith(selectedCategory: event.category));
    }
  }

  void changeSliderIndex(
    ChangeSlideIndexEvent event,
  ) {
    final currentState = state as HomeSuccessState;
    emit(currentState.copyWith(currentSlideIndex: event.slideIndex));
  }

  void getTeslaNews(
    GetTeslaNewEvent event,
  ) async {
    emit(HomeLoadingState());

    try {
      final news = await newsRepositories.setAndGetNews(isTesla: true);

      emit(HomeSuccessState(articles: news, originalArticles: news));
    } catch (e) {
      log('error on getting news by query $e');
      emit(HomeErrorState(errorMessage: e.toString()));
    }
  }

  void filterNews(
    FilterNewsEvent event,
  ) {
    if (state is HomeSuccessState) {
      final currentState = state as HomeSuccessState;
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
