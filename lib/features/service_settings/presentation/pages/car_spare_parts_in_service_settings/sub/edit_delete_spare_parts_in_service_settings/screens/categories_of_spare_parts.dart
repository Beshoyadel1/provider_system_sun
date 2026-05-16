import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import 'package:flutter/material.dart';

class CategoriesOfSpareParts extends StatelessWidget {
  final String categoryName;

  const CategoriesOfSpareParts({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.category,
      child: Row(
        spacing: 5,
        children: [
          TextInAppWidget(
            text: categoryName.isEmpty ? 'No Category' : categoryName,
            textSize: 14,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}