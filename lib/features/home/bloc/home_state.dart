abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  HomeSuccessState({
    this.selectedCategory,
    this.pickedImageLink,
    this.currentSlideIndex,
  });
  final String? selectedCategory;
  final String? pickedImageLink;
  final int? currentSlideIndex;

  HomeSuccessState copyWith({
    String? selectedCategory,
    String? pickedImageLink,
    int? currentSlideIndex,
  }) {
    return HomeSuccessState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      pickedImageLink: pickedImageLink ?? this.pickedImageLink,
      currentSlideIndex: currentSlideIndex ?? this.currentSlideIndex,
    );
  }
}

class HomeErrorState extends HomeState {
  HomeErrorState({required this.errorMessage});
  final String errorMessage;
}
