part of 'tesla_news_bloc.dart';

@immutable
abstract class TeslaNewsEvent {}

class DeleteteslaNewsByIdEvent extends TeslaNewsEvent {
  DeleteteslaNewsByIdEvent({required this.article});
  final Article article;
}

class EditNewsEvent extends TeslaNewsEvent {
  EditNewsEvent({
    required this.editedArticle,
    required this.lastArticle,
  });
  final Article editedArticle;
  final Article lastArticle;
}

class GetTeslaNewEvent extends TeslaNewsEvent {}

class RefleshNewsEvent extends TeslaNewsEvent {}

class FilterTeslaNewsEvent extends TeslaNewsEvent {
  FilterTeslaNewsEvent(
    this.enteredWord,
  );
  final String enteredWord;
}
