import 'package:flutter/material.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/home/bloc/home_state.dart';
import 'package:news_application/features/home/ui/category/bloc/category_bloc.dart';
import 'package:news_application/features/home/ui/category/bloc/category_event.dart';
import 'package:news_application/features/home/ui/category/category_news.dart';
import 'package:news_application/features/home/ui/country/bloc/country_bloc.dart';
import 'package:news_application/features/home/ui/country/bloc/country_event.dart';
import 'package:news_application/features/home/ui/country/country_news.dart';
import 'package:news_application/features/home/ui/profile/profile.dart';
import 'package:news_application/features/home/ui/tesla_news/tesla_news.dart';
import 'package:news_application/features/home/widgets/filtered_by_widget.dart';
import 'package:news_application/features/home/widgets/home_page_action_button.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/features/utils/sort_components.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();
  final currentPagenIndex = ValueNotifier(0);
  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
            child: FilteredByWidget(),
          ),
          MyBlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeErrorState) {
                return Center(
                  child: Text(AppTexts.wentWrong),
                );
              }
              if (state is HomeSuccessState) {
                return Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      currentPagenIndex.value = value;
                    },
                    children: [
                      TeslaNews(),
                      CategoryNews(),
                      CountryNews(),
                      Profile(),
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.blue,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: HomePageActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: currentPagenIndex,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    pageController.jumpToPage(0);
                    context.getBloc<HomeBloc>().add(GetTeslaNewEvent());
                  },
                  icon: Icon(
                    Icons.search,
                    color: value == 0 ? AppColors.blue : Colors.black,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    pageController.jumpToPage(1);

                    context.getBloc<CategoryBloc>().add(GetCategoryNewsEvent(
                          AppTexts.technology,
                        ));
                  },
                  icon: Image.asset(
                    AppImages.category.image,
                    height: 30,
                    width: 30,
                    color: value == 1 ? AppColors.blue : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                IconButton(
                  onPressed: () {
                    pageController.jumpToPage(2);

                    context.getBloc<CountryBloc>().add(GetCountryNewsEvent(
                        SortComponents.countryComponents.first));
                  },
                  icon: Image.asset(
                    AppImages.country.image,
                    width: 30,
                    height: 30,
                    color: value == 2 ? AppColors.blue : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    pageController.jumpToPage(3);
                  },
                  icon: Image.asset(
                    AppImages.profile.image,
                    height: 30,
                    width: 30,
                    color: value == 3 ? AppColors.blue : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
