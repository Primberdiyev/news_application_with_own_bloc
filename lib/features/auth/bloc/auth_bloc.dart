import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/features/auth/models/user_model.dart';
import 'package:news_application/features/utils/app_texts.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<SignUpEvent>(signUp);
    on<SignInEvent>(signIn);
    on<DeleteUserEvent>(deleteUser);
    on<CheckUserAuth>(checkUserAuth);
  }
  final HiveDatabaseService hiveService = HiveDatabaseService();

  void signUp(SignUpEvent event, Emitter<AuthState> emit) {
    emit(AuthLoadingState());
    try {
      hiveService.writeToLocal(userModel: event.userModel);
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  void signIn(SignInEvent event, Emitter<AuthState> emit) async {
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

  void deleteUser(DeleteUserEvent event, Emitter<AuthState> emit) {
    hiveService.clearUserModel();
  }

  void checkUserAuth(CheckUserAuth event, Emitter<AuthState> emit) async {
    await Future.delayed(Duration(seconds: 3));
    final UserModel? userModel = hiveService.getUserModel();
    if (userModel == null) {
      emit(AuthSuccessState(isRegistered: false));
      return;
    }
    emit(AuthSuccessState(isRegistered: true));
  }
}
