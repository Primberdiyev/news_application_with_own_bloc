import 'package:flutter/material.dart';
import 'package:news_application/features/routes/name_routes.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/app_texts.dart';


class QuestionTextWidget extends StatelessWidget {
  const QuestionTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppTexts.haveAccount,
          style:
              AppTextStyles.body14W400.copyWith(fontWeight: FontWeight.normal),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, NameRoutes.signUp),
          child: Text(
            AppTexts.createOne,
            style: AppTextStyles.body14W400
                .copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
