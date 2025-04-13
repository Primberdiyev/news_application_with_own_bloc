import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:news_application/features/home/ui/category/bloc/category_event.dart';
import 'package:news_application/features/home/ui/category/bloc/category_state.dart';
import 'package:news_application/my_bloc/private_bloc.dart';

class CategoryBloc extends PrivateBloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();

  @override
  void listener(CategoryEvent event) async {
    switch (event) {
      case GetCategoryNewsEvent():
         _getNewsEvent(event);
        break;
      case EditNewsEvent():
         _editNews(event);
        break;
      case DeleteNewsByIdEvent():
         _deleteNewsById(event);
        break;
    }
  }

  void _getNewsEvent(GetCategoryNewsEvent event) async {
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

  void _editNews(EditNewsEvent event) async {
    await databaseService.editNews(article: event.editedArticle);

    if (state is CategorySuccessState) {
      final currentState = state as CategorySuccessState;
      final news = List<Article>.from(currentState.articles ?? []);
      final index = news.indexOf(event.lastArticle);
      if (index != -1) {
        news[index] = event.editedArticle;
        emit(currentState.copyWith(articles: news));
      }
    }
  }

  void _deleteNewsById(DeleteNewsByIdEvent event) async {
    await databaseService.deleteNewsById(id: event.article.id);

    if (state is CategorySuccessState) {
      final currentState = state as CategorySuccessState;
      final news = List<Article>.from(currentState.articles ?? []);
      news.remove(event.article);
      emit(currentState.copyWith(articles: news));
    }
  }
}
