import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/home/widgets/news_item.dart';
import 'package:news_application/features/home/widgets/search_news.dart';

class TeslaNews extends StatelessWidget {
  const TeslaNews({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccessState) {
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
                            context.read<HomeBloc>().add(
                                  EditNewsEvent(
                                      editedArticle: newArticle,
                                      lastArticle: oldArticle),
                                ),
                        onDelete: () => context.read<HomeBloc>().add(
                              DeleteNewsByIdEvent(article: newData),
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
