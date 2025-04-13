part of 'country_bloc.dart';

@immutable
abstract class CountryEvent {}

class GetCountryNewsEvent extends CountryEvent {
  final CountryModel country;
  GetCountryNewsEvent(this.country);
}

class EditCountryNewsEvent extends CountryEvent {
  EditCountryNewsEvent({
    required this.editedArticle,
    required this.lastArticle,
  });
  final Article editedArticle;
  final Article lastArticle;
}

class DeleteCountryNewsByIdEvent extends CountryEvent {
  DeleteCountryNewsByIdEvent({required this.article});
  final Article article;
}
