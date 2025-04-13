import 'package:bloc/bloc.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:meta/meta.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<GetCategoryNewsEvent>(getNewsEvent);
    on<EditNewsEvent>(editNews);
    on<DeleteNewsByIdEvent>(deleteNewsById);
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();
  void getNewsEvent(
      GetCategoryNewsEvent event, Emitter<CategoryState> emit) async {
    final currentState = state;
    emit(CategoryLoadingState());
    try {
      final news = await newsRepositories.setAndGetNews(
        country: null,
        category: event.category,
        isTesla: false,
      );

      if (currentState is CategorySuccessState) {
        emit(currentState.copyWith(
          articles: news,
          selectedCategory: event.category,
        ));
      } else {
        emit(CategorySuccessState(
          articles: news,
          selectedCategory: event.category,
        ));
      }
    } catch (e) {
      emit(CategoryFailureState(e.toString()));
    }
  }

  void editNews(EditNewsEvent event, Emitter<CategoryState> emit) async {
    await databaseService.editNews(article: event.editedArticle);
    if (state is CategorySuccessState) {
      final currentState = state as CategorySuccessState;
      final news = currentState.articles ?? [];
      news[news.indexOf(event.lastArticle)] = event.editedArticle;
      emit(currentState.copyWith(articles: news));
    }
  }

  void deleteNewsById(
      DeleteNewsByIdEvent event, Emitter<CategoryState> emit) async {
    databaseService.deleteNewsById(id: event.article.id);
    if (state is CategorySuccessState) {
      final currentState = state as CategorySuccessState;
      final news = currentState.articles ?? [];
      news.remove(event.article);
      emit(currentState.copyWith(articles: news));
    }
  }
}
