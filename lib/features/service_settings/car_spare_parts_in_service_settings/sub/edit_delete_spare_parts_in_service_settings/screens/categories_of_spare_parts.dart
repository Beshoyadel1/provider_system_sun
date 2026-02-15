import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/service_settings/custom_widget/Column_image_text_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class CategoriesOfSpareParts extends StatelessWidget {
  const CategoriesOfSpareParts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.carCategory,
          textSize: 16,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.orangeColor,
        ),
        Row(
          spacing: 10,
          children: [
            ColumnImageTextWidget(imagePath: AppImageKeys.car500, text: 'GTR'),
            ColumnImageTextWidget(imagePath: AppImageKeys.car500, text: 'GTR'),
            ColumnImageTextWidget(imagePath: AppImageKeys.car500, text: 'GTR'),
          ],
        )
      ],
    );
  }
}
