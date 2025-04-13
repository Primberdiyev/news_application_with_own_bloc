import 'package:flutter/material.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_text_styles.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonHeight,
    required this.color,
    required this.text,
    required this.textColor,
    required this.function,
    this.isLoading = false,
  });
  final double buttonHeight;
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback function;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(buttonHeight),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: function,
      child: isLoading
          ? SizedBox(
              height: buttonHeight,
              width: buttonHeight,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              ),
            )
          : Text(
              text,
              style: AppTextStyles.head20W600.copyWith(
                color: textColor,
              ),
            ),
    );
  }
}
