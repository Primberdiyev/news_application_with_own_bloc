part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class GetCategoryNewsEvent extends CategoryEvent {
  GetCategoryNewsEvent(this.category);
  final String category;
}

class EditNewsEvent extends CategoryEvent {
  EditNewsEvent({
    required this.editedArticle,
    required this.lastArticle,
  });
  final Article editedArticle;
  final Article lastArticle;
}

class DeleteNewsByIdEvent extends CategoryEvent {
  DeleteNewsByIdEvent({required this.article});
  final Article article;
}
