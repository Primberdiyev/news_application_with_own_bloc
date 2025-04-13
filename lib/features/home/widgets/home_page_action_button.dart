import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:news_application/features/home/ui/tesla_news/bloc/tesla_news_bloc.dart';
import 'package:news_application/features/routes/name_routes.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class HomePageActionButton extends StatelessWidget {
  const HomePageActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SpeedDial(
        activeIcon: Icons.close,
        activeBackgroundColor: AppColors.blue,
        backgroundColor: AppColors.blue,
        buttonSize: const Size.fromRadius(30),
        childrenButtonSize: const Size(60, 60),
        spaceBetweenChildren: 20,
        children: [
          SpeedDialChild(
            shape: const StadiumBorder(),
            child: Icon(Icons.add),
            backgroundColor: Colors.white,
            onTap: () {
              Navigator.pushNamed(context, NameRoutes.addtArticle);
            },
          ),
          SpeedDialChild(
            shape: const StadiumBorder(),
            child: Icon(Icons.refresh),
            backgroundColor: Colors.white,
            onTap: () {
              context.getBloc<TeslaNewsBloc>().add(RefleshNewsEvent());
            },
          ),
        ],
        child: Image.asset(
          AppImages.attachment.image,
          height: 30,
          width: 30,
          color: AppColors.white,
        ),
      ),
      onPressed: () {},
    );
  }
}
