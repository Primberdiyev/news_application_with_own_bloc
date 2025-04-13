import 'package:flutter/material.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/auth/models/user_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_event.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_state.dart';
import 'package:news_application/my_bloc/private_bloc.dart';

class ProfileBloc extends PrivateBloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  void listener(ProfileEvent event) {
    switch (event) {
      case GetUserModel _:
        getUserModel(event);
      case PickUserImageEvent _:
        pickUserImage(event);
      case ChangeShowPasswordValueEvent _:
        changeShowPasswordValue(event);
      case DeleteUserModelEvent _:
        deleteUserModel(event);
      case ChangeUserDetailEvent _:
        changeUserDetail(event);
    }
  }

  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

  void getUserModel(
    GetUserModel event,
  ) async {
    final currentState = state;
    final userModel = hiveDatabaseService.getUserModel();
    if (currentState is ProfileSuccessState) {
      emit(currentState.copyWith(userModel: userModel));
    } else {
      emit(ProfileSuccessState(
          userModel: userModel ?? ({} as UserModel), isObscured: false));
    }
  }

  void pickUserImage(
    PickUserImageEvent event,
  ) async {
    try {
      final currentState = state as ProfileSuccessState;
      await hiveDatabaseService.pickUserImage();
      final userModel = hiveDatabaseService.getUserModel();
      emit(currentState.copyWith(userModel: userModel));
    } catch (e) {
      debugPrint('error $e');
    }
  }

  void changeShowPasswordValue(
    ChangeShowPasswordValueEvent event,
  ) {
    final currentState = state as ProfileSuccessState;
    emit(currentState.copyWith(isObscured: !currentState.isObscured));
  }

  void deleteUserModel(
    DeleteUserModelEvent event,
  ) {
    hiveDatabaseService.deleteUserModel();
  }

  void changeUserDetail(ChangeUserDetailEvent event) {
    final currentState = state as ProfileSuccessState;
    hiveDatabaseService.writeToLocal(userModel: event.userModel);
    final userModel = hiveDatabaseService.getUserModel();
    emit(currentState.copyWith(userModel: userModel));
  }
}
