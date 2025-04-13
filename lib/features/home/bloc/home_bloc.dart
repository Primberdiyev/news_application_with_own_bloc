import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/auth/models/user_model.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/models/country_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:news_application/features/utils/sort_components.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<DeleteNewsByIdEvent>(deleteNewsById);
    on<EditNewsEvent>(editNews);
    on<RefleshNewsEvent>(refleshNews);
    on<PickImageEvent>(pickImage);
    on<CreateNewArticle>(createNewArticle);
    on<ChangeCategoryEvent>(changeCategory);
    on<ChangeSlideIndexEvent>(changeSliderIndex);
    on<GetTeslaNewEvent>(getTeslaNews);
    on<FilterNewsEvent>(filterNews);
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final defaultCountry = SortComponents.countryComponents.first;
  final defaultCategory = SortComponents.categories.first;
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

  void deleteNewsById(
      DeleteNewsByIdEvent event, Emitter<HomeState> emit) async {
    databaseService.deleteNewsById(id: event.article.id);
    if (state is HomeSuccessState) {
      final currentState = state as HomeSuccessState;
      final news = currentState.articles;
      news.remove(event.article);
      emit(currentState.copyWith(articles: news));
    }
  }

  void editNews(EditNewsEvent event, Emitter<HomeState> emit) async {
    await databaseService.editNews(article: event.editedArticle);
    if (state is HomeSuccessState) {
      final currentState = state as HomeSuccessState;
      final news = currentState.articles;
      news[news.indexOf(event.lastArticle)] = event.editedArticle;
      emit(currentState.copyWith(articles: news));
    }
  }

  void refleshNews(RefleshNewsEvent event, Emitter<HomeState> emit) async {
    if (state is HomeSuccessState) {
      await databaseService.clearDatabase();
      add(GetTeslaNewEvent());
    }
  }

  void pickImage(PickImageEvent event, Emitter<HomeState> emit) async {
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

  void createNewArticle(CreateNewArticle event, Emitter<HomeState> emit) async {
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

  void changeCategory(ChangeCategoryEvent event, Emitter<HomeState> emit) {
    if (state is HomeSuccessState) {
      final currentstate = state as HomeSuccessState;
      emit(currentstate.copyWith(selectedCategory: event.category));
    }
  }

  void changeSliderIndex(ChangeSlideIndexEvent event, Emitter<HomeState> emit) {
    final currentState = state as HomeSuccessState;
    emit(currentState.copyWith(currentSlideIndex: event.slideIndex));
  }

  void getTeslaNews(GetTeslaNewEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    try {
      final news = await newsRepositories.setAndGetNews(isTesla: true);

      emit(HomeSuccessState(articles: news, originalArticles: news));
    } catch (e) {
      log('error on getting news by query $e');
      emit(HomeErrorState(errorMessage: e.toString()));
    }
  }

  void filterNews(FilterNewsEvent event, Emitter<HomeState> emit) {
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
