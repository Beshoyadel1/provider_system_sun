import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class StockOfSpareParts extends StatelessWidget {
  final String stock;

  const StockOfSpareParts({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.inStock,
      child: TextInAppWidget(
        text: stock.isEmpty ? 'No description available' : stock,
        textSize: 14,
        fontWeightIndex: FontSelectionData.regularFontFamily,
        textColor: AppColors.blackColor.withOpacity(0.8),
      ),
    );
  }
}
