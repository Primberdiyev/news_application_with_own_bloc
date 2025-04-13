import 'package:flutter/material.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({
    super.key,
  });

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  final TextEditingController controller = TextEditingController();
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.getBloc<HomeBloc>().add(FilterNewsEvent(controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) => _onSearchChanged(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.darkgrey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
