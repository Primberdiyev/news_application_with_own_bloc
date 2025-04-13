import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/auth/models/user_model.dart';
import 'package:news_application/features/home/repositories/news_repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GetUserModel>(getUserModel);
    on<PickUserImageEvent>(pickUserImage);
    on<ChangeShowPasswordValueEvent>(changeShowPasswordValue);
    on<DeleteUserModelEvent>(deleteUserModel);
    on<ChangeUserDetailEvent>(changeUserDetail);
  }
  final IsarDatabaseService databaseService = IsarDatabaseService();
  final NewsRepositories newsRepositories = NewsRepositories();
  final HiveDatabaseService hiveDatabaseService = HiveDatabaseService();

  void getUserModel(GetUserModel event, Emitter<ProfileState> emit) async {
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
      PickUserImageEvent event, Emitter<ProfileState> emit) async {
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
      ChangeShowPasswordValueEvent event, Emitter<ProfileState> emit) {
    final currentState = state as ProfileSuccessState;
    emit(currentState.copyWith(isObscured: !currentState.isObscured));
  }

  void deleteUserModel(DeleteUserModelEvent event, Emitter<ProfileState> emit) {
    hiveDatabaseService.deleteUserModel();
  }

  void changeUserDetail(
      ChangeUserDetailEvent event, Emitter<ProfileState> emit) {
    final currentState = state as ProfileSuccessState;
    hiveDatabaseService.writeToLocal(userModel: event.userModel);
    final userModel = hiveDatabaseService.getUserModel();
    emit(currentState.copyWith(userModel: userModel));
  }
}
