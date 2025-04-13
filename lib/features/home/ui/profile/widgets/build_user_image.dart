import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_bloc.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_event.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_state.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class BuildUserImage extends StatelessWidget {
  const BuildUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyBlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String? imageLink = (state is ProfileSuccessState)
            ? state.userModel.imageAssetLink
            : null;
        return GestureDetector(
          onTap: () {
            context.getBloc<ProfileBloc>().add(PickUserImageEvent());
          },
          child: CircleAvatar(
            radius: 80,
            backgroundImage: imageLink != null && File(imageLink).existsSync()
                ? FileImage(File(imageLink))
                : AssetImage(
                    AppImages.userDefault.image,
                  ) as ImageProvider,
          ),
        );
      },
    );
  }
}
