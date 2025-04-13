import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/models/country_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryInitial()) {
    on<GetCountryNewsEvent>(getCountryNews);
    on<EditCountryNewsEvent>(editNews);
    on<DeleteCountryNewsByIdEvent>(deleteNewsById);
  }
  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

  void getCountryNews(
      GetCountryNewsEvent event, Emitter<CountryState> emit) async {
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

  void deleteNewsById(
      DeleteCountryNewsByIdEvent event, Emitter<CountryState> emit) async {
    databaseService.deleteNewsById(id: event.article.id);
    if (state is CountrySuccessState) {
      final currentState = state as CountrySuccessState;
      final news = currentState.articles ?? [];
      news.remove(event.article);
      emit(currentState.copyWith(articles: news));
    }
  }

  void editNews(EditCountryNewsEvent event, Emitter<CountryState> emit) async {
    await databaseService.editNews(article: event.editedArticle);
    if (state is CountrySuccessState) {
      final currentState = state as CountrySuccessState;
      final news = currentState.articles ?? [];
      news[news.indexOf(event.lastArticle)] = event.editedArticle;
      emit(currentState.copyWith(articles: news));
    }
  }
}
