import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class TextDescriptionOfSpareParts extends StatelessWidget {
  final String description;

  const TextDescriptionOfSpareParts({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.description,
      child: TextInAppWidget(
        text: description.isEmpty ? 'No description available' : description,
        textSize: 14,
        fontWeightIndex: FontSelectionData.regularFontFamily,
        textColor: AppColors.blackColor.withOpacity(0.8),
      ),
    );
  }
}
