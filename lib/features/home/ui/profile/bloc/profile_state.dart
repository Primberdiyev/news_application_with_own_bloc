import 'package:news_application/features/auth/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final UserModel userModel;
  final bool isObscured;
  ProfileSuccessState({required this.userModel, required this.isObscured});

  ProfileSuccessState copyWith({UserModel? userModel, bool? isObscured}) {
    return ProfileSuccessState(
      userModel: userModel ?? this.userModel,
      isObscured: isObscured ?? this.isObscured,
    );
  }
}

class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
