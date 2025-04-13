part of 'category_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategorySuccessState extends CategoryState {
  final List<Article>? articles;
  final String? selectedCategory;
  CategorySuccessState({
    this.articles,
    this.selectedCategory,
  });

  CategorySuccessState copyWith(
      {List<Article>? articles, String? selectedCategory}) {
    return CategorySuccessState(
      articles: articles ?? this.articles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class CategoryLoadingState extends CategoryState {}

class CategoryFailureState extends CategoryState {
  final String errorMessage;
  CategoryFailureState(this.errorMessage);
}
