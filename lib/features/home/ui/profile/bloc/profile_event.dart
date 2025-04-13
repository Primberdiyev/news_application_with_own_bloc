part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetUserModel extends ProfileEvent {}

class PickUserImageEvent extends ProfileEvent {}

class DeleteUserModelEvent extends ProfileEvent {}

class ChangeUserDetailEvent extends ProfileEvent {
  ChangeUserDetailEvent({required this.userModel});
  final UserModel userModel;
}

class ChangeShowPasswordValueEvent extends ProfileEvent {}
