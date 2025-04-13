import 'package:flutter/material.dart';
import 'package:news_application/core/ui_kit/custom_button.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/widgets/cached_image_widget.dart';
import 'package:news_application/features/utils/app_colors.dart';
import 'package:news_application/features/utils/app_text_styles.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/features/utils/constants.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.article,
    required this.onSave,
  });

  final Article article;
  final void Function(Article oldArticle, Article newArticle) onSave;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleEditingController.text = widget.article.title ?? "";
    descriptionController.text = widget.article.description ?? "";
    super.initState();
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedImageWidget(
              imageLink: widget.article.urlToImage ?? Constants.errorImageUrl,
              imageWidth: size.width - 20,
            ),
            const SizedBox(height: 20),
            Text(AppTexts.title, style: AppTextStyles.head20W600),
            TextFormField(
              maxLines: null,
              controller: titleEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppTexts.description, style: AppTextStyles.head20W600),
            TextFormField(
              maxLines: null,
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: 40,
                    color: AppColors.textFieldColor,
                    text: AppTexts.cancel,
                    textColor: AppColors.black,
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    buttonHeight: 40,
                    color: AppColors.primary,
                    text: AppTexts.save,
                    textColor: AppColors.white,
                    function: () {
                      final oldArticle = widget.article;
                      final newArticle = oldArticle.copyWith(
                        title: titleEditingController.text,
                        description: descriptionController.text,
                      );
                      if (oldArticle != newArticle) {
                        widget.onSave(oldArticle, newArticle);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
