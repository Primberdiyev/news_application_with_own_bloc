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
    }
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final defaultCountry = SortComponents.countryComponents.first;
  final defaultCategory = SortComponents.categories.first;
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

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
    final currentState = state;
    if (currentState is HomeSuccessState) {
      emit(currentState.copyWith(currentSlideIndex: event.slideIndex));
    } else {
      emit(HomeSuccessState(currentSlideIndex: event.slideIndex));
    }
  }
}
