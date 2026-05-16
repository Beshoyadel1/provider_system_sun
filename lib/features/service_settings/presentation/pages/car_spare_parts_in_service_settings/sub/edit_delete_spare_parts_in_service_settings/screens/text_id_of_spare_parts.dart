import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class TextIdOfSpareParts extends StatelessWidget {
  final String id;

  const TextIdOfSpareParts({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.identity,
      child: TextInAppWidget(
        text: id.isEmpty ? 'No id available' : id,
        textSize: 14,
        fontWeightIndex: FontSelectionData.regularFontFamily,
        textColor: AppColors.blackColor.withOpacity(0.8),
      ),
    );
  }
}
