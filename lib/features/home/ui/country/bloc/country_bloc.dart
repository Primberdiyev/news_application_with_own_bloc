import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:news_application/features/home/ui/country/bloc/country_event.dart';
import 'package:news_application/features/home/ui/country/bloc/country_state.dart';
import 'package:news_application/my_bloc/private_bloc.dart';

class CountryBloc extends PrivateBloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryInitial());

  @override
  void listener(CountryEvent event) {
    switch (event) {
      case GetCountryNewsEvent _:
        getCountryNews(event);
      case DeleteCountryNewsByIdEvent _:
        deleteNewsById(event);
      case EditCountryNewsEvent _:
        editNews(event);
    }
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

  void getCountryNews(GetCountryNewsEvent event) async {
    final currentState = state;
    emit(CountryLoadingState());
    try {
      final news = await newsRepositories.setAndGetNews(
        country: event.country.shortName,
        category: null,
        isTesla: false,
      );
      if (currentState is CountrySuccessState) {
        emit(currentState.copyWith(
          articles: news,
          selectedCountry: event.country,
        ));
      } else {
        emit(CountrySuccessState(
          articles: news,
          selectedCountry: event.country,
        ));
      }
    } catch (e) {
      emit(CountryErrorState(e.toString()));
    }
  }

  void deleteNewsById(DeleteCountryNewsByIdEvent event) async {
    databaseService.deleteNewsById(id: event.article.id);
    if (state is CountrySuccessState) {
      final currentState = state as CountrySuccessState;
      final news = currentState.articles ?? [];
      news.remove(event.article);
      emit(currentState.copyWith(articles: news));
    }
  }

  void editNews(EditCountryNewsEvent event) async {
    await databaseService.editNews(article: event.editedArticle);
    if (state is CountrySuccessState) {
      final currentState = state as CountrySuccessState;
      final news = currentState.articles ?? [];
      news[news.indexOf(event.lastArticle)] = event.editedArticle;
      emit(currentState.copyWith(articles: news));
    }
  }
}
