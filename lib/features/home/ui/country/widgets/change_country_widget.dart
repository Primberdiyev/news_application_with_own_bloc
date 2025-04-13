import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/features/home/models/country_model.dart';
import 'package:news_application/features/home/ui/country/bloc/country_bloc.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/sort_components.dart';

class ChangeCountryWidget extends StatefulWidget {
  const ChangeCountryWidget({
    super.key,
    required this.selectedItem,
  });
  final CountryModel selectedItem;
  @override
  State<ChangeCountryWidget> createState() => _ChangeCategoryWidgetState();
}

class _ChangeCategoryWidgetState extends State<ChangeCountryWidget> {
  final items = SortComponents.countryComponents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isSelected = item.name == widget.selectedItem.name;
          return GestureDetector(
            onTap: () {
              context.read<CountryBloc>().add(GetCountryNewsEvent(item));
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
                  Image.asset(
                    item.imageAsset,
                    height: 24,
                    width: 24,
                  ),
                  Text(
                    item.name,
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
