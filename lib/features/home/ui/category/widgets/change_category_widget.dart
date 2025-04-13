import 'package:flutter/widgets.dart';
import 'package:news_application/features/home/ui/category/bloc/category_bloc.dart';
import 'package:news_application/features/home/ui/category/bloc/category_event.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/sort_components.dart';
import 'package:news_application/my_bloc/my_bloc_ext.dart';

class ChangeCategoryWidget extends StatefulWidget {
  const ChangeCategoryWidget({
    super.key,
    required this.selectedItem,
  });
  final String selectedItem;
  @override
  State<ChangeCategoryWidget> createState() => _ChangeCategoryWidgetState();
}

class _ChangeCategoryWidgetState extends State<ChangeCategoryWidget> {
  final items = SortComponents.categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isSelected = item == widget.selectedItem;
          return GestureDetector(
            onTap: () {
              context.getBloc<CategoryBloc>().add(GetCategoryNewsEvent(item));
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isSelected ? AppColors.primary : AppColors.textFieldColor,
              ),
              child: Row(
                children: [
                  Text(
                    item,
                    style: AppTextStyles.body16W400.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
