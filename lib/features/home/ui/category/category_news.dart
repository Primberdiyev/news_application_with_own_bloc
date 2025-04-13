import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/ui/category/bloc/category_bloc.dart';
import 'package:news_application/features/home/ui/category/widgets/change_category_widget.dart';
import 'package:news_application/features/home/widgets/failure_widget.dart';
import 'package:news_application/features/home/widgets/loading_widget.dart';
import 'package:news_application/features/home/widgets/news_item.dart';
import 'package:news_application/features/home/widgets/slider_news_widget.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({super.key});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                ChangeCategoryWidget(
                  selectedItem: state.selectedCategory ?? "",
                ),
                SliderNewsWidget(
                  articles: state.articles ?? [],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.articles?.length,
                    itemBuilder: (context, index) {
                      final newData = state.articles?[index] ?? ({} as Article);
                      return NewsItem(
                        article: newData,
                        onDelete: () {
                          context.read<CategoryBloc>().add(
                                DeleteNewsByIdEvent(article: newData),
                              );
                        },
                        onEdit: (oldArticle, newArticle) {
                          context.read<CategoryBloc>().add(EditNewsEvent(
                              editedArticle: newArticle,
                              lastArticle: oldArticle));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is CategoryLoadingState) {
          return LoadingWidget();
        }
        return FailureWidget();
      },
    );
  }
}
