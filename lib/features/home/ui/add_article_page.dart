import 'package:flutter/material.dart';
import 'package:news_application/core/ui_kit/custom_button.dart';
import 'package:news_application/core/ui_kit/custom_text_field.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/home/bloc/home_state.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/widgets/select_category.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/features/utils/sort_components.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticleDialogState();
}

class _AddArticleDialogState extends State<AddArticlePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorController = TextEditingController();
  late String selectedCategory;

  @override
  void initState() {
    final state = context.getBloc<HomeBloc>().state;
    final defaultCategory = SortComponents.categories.first;
    selectedCategory = state is HomeSuccessState
        ? state.selectedCategory ?? defaultCategory
        : defaultCategory;

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 70),
        children: [
          MyBlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final isImageLoaded =
                  (state is HomeSuccessState) && state.pickedImageLink != null;
              return Container(
                height: 180,
                width: 180,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textFieldColor,
                ),
                child: GestureDetector(
                  onTap: () {
                    context.getBloc<HomeBloc>().add(PickImageEvent());
                  },
                  child: (state is HomeLoadingState)
                      ? Center(child: CircularProgressIndicator())
                      : isImageLoaded
                          ? CircleAvatar(
                              radius: 90,
                              child: Image.network(
                                state.pickedImageLink!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                width: 180,
                                fit: BoxFit.fill,
                                height: 180,
                              ),
                            )
                          : Image.asset(AppImages.add.image),
                ),
              );
            },
          ),
          Text(
            AppTexts.title,
            style: AppTextStyles.head20W600,
          ),
          CustomTextField(
            controller: titleController,
            hintText: AppTexts.enterTitle,
            maxLine: 2,
            topPaddingSize: 0,
          ),
          SizedBox(height: 30),
          Text(
            AppTexts.description,
            style: AppTextStyles.head20W600,
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: AppTexts.enterDescription,
            maxLine: 2,
            topPaddingSize: 0,
          ),
          SizedBox(height: 30),
          Text(
            AppTexts.author,
            style: AppTextStyles.head20W600,
          ),
          CustomTextField(
            controller: authorController,
            hintText: AppTexts.enterDescription,
            topPaddingSize: 0,
          ),
          SizedBox(height: 30),
          Text(
            AppTexts.category,
            style: AppTextStyles.head20W600,
          ),
          SelectCategory(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                buttonHeight: 50,
                color: AppColors.textFieldColor,
                text: AppTexts.cancel,
                textColor: AppColors.black,
                function: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(width: 30),
            MyBlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType,
              builder: (context, state) {
                return Expanded(
                  child: CustomButton(
                    buttonHeight: 50,
                    color: AppColors.primary,
                    text: AppTexts.save,
                    textColor: AppColors.white,
                    isLoading: state is HomeLoadingState,
                    function: () {
                      Article? newArticle;
                      if (state is HomeSuccessState) {
                        final category = state.selectedCategory ??
                            SortComponents.categories.first;
                        final urlImage = state.pickedImageLink;
                        newArticle = Article(
                          title: titleController.text,
                          description: descriptionController.text,
                          author: authorController.text,
                          category: category,
                          urlToImage: urlImage,
                          isFromAPI: false,
                          publishedAt: DateTime.now().toString(),
                        );
                        context.getBloc<HomeBloc>().add(
                              CreateNewArticle(
                                createdArticle: newArticle,
                                selectedCategory: selectedCategory,
                              ),
                            );
                      }
                      if (newArticle != null && state is HomeSuccessState) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
