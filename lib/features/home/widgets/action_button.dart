import 'package:flutter/material.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/bloc/home_state.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';


class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.function,
  });
  final IconData icon;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return MyBlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Visibility(
          visible: (state is! HomeLoadingState),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.primary,
              minimumSize: Size(60, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: function,
            child: Icon(
              icon,
              color: AppColors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
