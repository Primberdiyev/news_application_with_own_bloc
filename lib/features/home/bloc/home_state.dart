part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  HomeSuccessState({
    required this.articles,
    this.selectedCountry,
    this.selectedCategory,
    this.pickedImageLink,
    this.currentSlideIndex,
    this.originalArticles,
  });
  final List<Article> articles;
  final List<Article>? originalArticles;
  final CountryModel? selectedCountry;
  final String? selectedCategory;
  final String? pickedImageLink;
  final int? currentSlideIndex;

  HomeSuccessState copyWith({
    List<Article>? articles,
    List<Article>? originalArticles,
    CountryModel? selectedCountry,
    String? filterType,
    String? selectedCategory,
    String? pickedImageLink,
    int? currentSlideIndex,
    UserModel? userModel,
    bool? isObscured,
  }) {
    return HomeSuccessState(
      articles: articles ?? this.articles,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      pickedImageLink: pickedImageLink ?? this.pickedImageLink,
      currentSlideIndex: currentSlideIndex ?? this.currentSlideIndex,
      originalArticles: originalArticles ?? this.originalArticles,
    );
  }
}

class HomeErrorState extends HomeState {
  HomeErrorState({required this.errorMessage});
  final String errorMessage;
}
