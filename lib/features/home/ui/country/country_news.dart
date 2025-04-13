import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/ui/country/bloc/country_bloc.dart';
import 'package:news_application/features/home/ui/country/widgets/change_country_widget.dart';
import 'package:news_application/features/home/widgets/failure_widget.dart';
import 'package:news_application/features/home/widgets/loading_widget.dart';
import 'package:news_application/features/home/widgets/news_item.dart';
import 'package:news_application/features/home/widgets/slider_news_widget.dart';
import 'package:news_application/features/utils/sort_components.dart';

class CountryNews extends StatefulWidget {
  const CountryNews({super.key});

  @override
  State<CountryNews> createState() => _CountryNewsState();
}

class _CountryNewsState extends State<CountryNews> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        if (state is CountrySuccessState) {
          final selectedItem =
              state.selectedCountry ?? SortComponents.countryComponents.first;
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
                ChangeCountryWidget(selectedItem: selectedItem),
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
                        onEdit: (oldArticle, newArticle) =>
                            context.read<CountryBloc>().add(
                                  EditCountryNewsEvent(
                                      editedArticle: newArticle,
                                      lastArticle: oldArticle),
                                ),
                        onDelete: () => context.read<CountryBloc>().add(
                              DeleteCountryNewsByIdEvent(article: newData),
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is CountryErrorState) {
          return FailureWidget();
        }
        return LoadingWidget();
      },
    );
  }
}
