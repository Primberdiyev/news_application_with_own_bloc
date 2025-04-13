import 'package:flutter/material.dart';
import 'package:news_application/features/home/ui/tesla_news/bloc/tesla_news_bloc.dart';
import 'package:news_application/features/home/widgets/news_item.dart';
import 'package:news_application/features/home/widgets/search_news.dart';
import 'package:news_application/my_bloc/my_bloc_builder.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class TeslaNews extends StatelessWidget {
  const TeslaNews({super.key});

  @override
  Widget build(BuildContext context) {
    return MyBlocBuilder<TeslaNewsBloc, TeslaNewsState>(
      builder: (context, state) {
        if (state is TeslaNewsSucessState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SearchNews(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final newData = state.articles[index];
                      return NewsItem(
                        article: newData,
                        onEdit: (oldArticle, newArticle) =>
                            context.getBloc<TeslaNewsBloc>().add(
                                  EditNewsEvent(
                                      editedArticle: newArticle,
                                      lastArticle: oldArticle),
                                ),
                        onDelete: () => context.getBloc<TeslaNewsBloc>().add(
                              DeleteteslaNewsByIdEvent(article: newData),
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
