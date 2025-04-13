import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_bloc.dart';
import 'package:news_application/features/utils/app_images.dart';

class BuildUserImage extends StatelessWidget {
  const BuildUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String? imageLink = (state is ProfileSuccessState)
            ? state.userModel.imageAssetLink
            : null;
        return GestureDetector(
          onTap: () {
            context.read<ProfileBloc>().add(PickUserImageEvent());
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
