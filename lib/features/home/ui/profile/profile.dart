import 'package:flutter/material.dart';
import 'package:news_application/core/ui_kit/custom_button.dart';
import 'package:news_application/core/ui_kit/custom_text_field.dart';
import 'package:news_application/features/auth/models/user_model.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_bloc.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_event.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_state.dart';
import 'package:news_application/features/home/ui/profile/widgets/build_user_image.dart';
import 'package:news_application/features/routes/name_routes.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/my_bloc/my_bloc_consumer.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.getBloc<ProfileBloc>().add(GetUserModel());
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyBlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        String userName =
            (state is ProfileSuccessState) ? state.userModel.firstName : '';
        String lastName =
            (state is ProfileSuccessState) ? state.userModel.password : '';
        nameController.text = userName;
        passwordController.text = lastName;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              BuildUserImage(),
              SizedBox(height: 20),
              CustomTextField(
                  controller: nameController, hintText: AppTexts.firstName),
              CustomTextField(
                controller: passwordController,
                hintText: AppTexts.password,
                showPassword:
                    state is ProfileSuccessState ? state.isObscured : false,
                maxLine: 1,
                function: () => context
                    .getBloc<ProfileBloc>()
                    .add(ChangeShowPasswordValueEvent()),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.getBloc<ProfileBloc>().add(
                        DeleteUserModelEvent(),
                      );
                  Navigator.pushReplacementNamed(context, NameRoutes.signIn);
                },
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.logOut.image,
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      AppTexts.logOut,
                      style: AppTextStyles.body18W400
                          .copyWith(color: AppColors.red),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonHeight: 50,
                      color: AppColors.primary,
                      text: AppTexts.save,
                      textColor: AppColors.white,
                      function: () {
                        final UserModel? userModel =
                            state is ProfileSuccessState
                                ? state.userModel
                                : null;
                        final newUserModel = userModel?.copyWith(
                              firstName: nameController.text,
                              password: passwordController.text,
                            ) ??
                            ({} as UserModel);
                        context.getBloc<ProfileBloc>().add(
                            ChangeUserDetailEvent(userModel: newUserModel));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        );
      },
    );
  }
}
