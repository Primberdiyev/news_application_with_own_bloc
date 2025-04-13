part of 'country_bloc.dart';

@immutable
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
