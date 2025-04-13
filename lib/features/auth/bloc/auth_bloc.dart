import 'package:meta/meta.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/features/auth/models/user_model.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/my_bloc/private_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends PrivateBloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  void listener(AuthEvent event) {
    switch (event) {
      case SignUpEvent _:
        signUp(event);
      case SignInEvent _:
        signIn(event);
      case DeleteUserEvent _:
        deleteUser(event);
      case CheckUserAuth _:
        checkUserAuth(event);
    }
  }

  final HiveDatabaseService hiveService = HiveDatabaseService();

  void signUp(
    SignUpEvent event,
  ) {
    emit(AuthLoadingState());
    try {
      hiveService.writeToLocal(userModel: event.userModel);
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  void signIn(
    SignInEvent event,
  ) async {
    emit(AuthLoadingState());
    try {
      final UserModel? userModel = hiveService.getUserModel();
      if (userModel == null ||
          (userModel.email != event.email ||
              userModel.password != event.password)) {
        emit(AuthErrorState(errorMessage: AppTexts.notRegistered));
        return;
      }

      emit(AuthSuccessState());
    } catch (e) {
      AuthErrorState(errorMessage: e.toString());
    }
  }

  void deleteUser(
    DeleteUserEvent event,
  ) {
    hiveService.clearUserModel();
  }

  void checkUserAuth(CheckUserAuth event) async {
    await Future.delayed(Duration(seconds: 3));
    final UserModel? userModel = hiveService.getUserModel();
    if (userModel == null) {
      emit(AuthSuccessState(isRegistered: false));
      return;
    }
    emit(AuthSuccessState(isRegistered: true));
  }
}
