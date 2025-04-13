
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/models/country_model.dart';

abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountrySuccessState extends CountryState {
  final List<Article>? articles;
  final CountryModel? selectedCountry;
  CountrySuccessState({
    this.articles,
    this.selectedCountry,
  });
  CountrySuccessState copyWith(
      {List<Article>? articles, CountryModel? selectedCountry}) {
    return CountrySuccessState(
        articles: articles ?? this.articles,
        selectedCountry: selectedCountry ?? this.selectedCountry);
  }
}

class CountryLoadingState extends CountryState {}

class CountryErrorState extends CountryState {
  final String errorMessage;
  CountryErrorState(this.errorMessage);
}
