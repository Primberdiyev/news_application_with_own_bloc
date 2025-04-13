
import 'package:news_application/features/auth/models/user_model.dart';

abstract class ProfileEvent {}

class GetUserModel extends ProfileEvent {}

class PickUserImageEvent extends ProfileEvent {}

class DeleteUserModelEvent extends ProfileEvent {}

class ChangeUserDetailEvent extends ProfileEvent {
  ChangeUserDetailEvent({required this.userModel});
  final UserModel userModel;
}

class ChangeShowPasswordValueEvent extends ProfileEvent {}
