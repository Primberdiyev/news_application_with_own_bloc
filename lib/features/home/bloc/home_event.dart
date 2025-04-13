import 'package:news_application/features/home/models/article_model.dart';

abstract class HomeEvent {}

class FilterNewsEvent extends HomeEvent {
  FilterNewsEvent(
    this.enteredWord,
  );
  final String enteredWord;
}

class DeleteNewsByIdEvent extends HomeEvent {
  DeleteNewsByIdEvent({required this.article});
  Article article;
}

class EditNewsEvent extends HomeEvent {
  EditNewsEvent({
    required this.editedArticle,
    required this.lastArticle,
  });
  Article editedArticle;
  Article lastArticle;
}

class RefleshNewsEvent extends HomeEvent {}

class PickImageEvent extends HomeEvent {}

class CreateNewArticle extends HomeEvent {
  CreateNewArticle({
    required this.createdArticle,
    required this.selectedCategory,
  });
  Article createdArticle;
  String selectedCategory;
}

class ChangeCategoryEvent extends HomeEvent {
  ChangeCategoryEvent(this.category);
  String category;
}

class ChangeSlideIndexEvent extends HomeEvent {
  ChangeSlideIndexEvent(this.slideIndex);
  int slideIndex;
}

class GetTeslaNewEvent extends HomeEvent {}
