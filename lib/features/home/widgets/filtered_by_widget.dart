import 'package:flutter/material.dart';
import 'package:news_application/features/home/ui/tesla_news/bloc/tesla_news_bloc.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';

class FilteredByWidget extends StatefulWidget {
  const FilteredByWidget({super.key});

  @override
  State<FilteredByWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FilteredByWidget> {
  List<String> filters = [AppTexts.country, AppTexts.category];

  @override
  Widget build(BuildContext context) {
    return MyBlocBuilder<TeslaNewsBloc, TeslaNewsState>(
      builder: (context, state) {
        if (state is TeslaNewsSucessState) {
          return Row(
            children: [
              Image.asset(
                AppImages.splash.image,
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                AppTexts.bbcApp,
                style: AppTextStyles.head24W600.copyWith(fontSize: 20),
              ),
              Spacer(),
              Icon(Icons.notification_important),
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
