import 'package:flutter/material.dart';
import '../../../../core/utilies/map_of_all_app.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/pages_widgets/button_widget.dart';
import '../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../core/theming/text_styles.dart';
class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.versionKey,
          textSize: 12,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),
        TextInAppWidget(
          text: ValuesOfAllApp.version,
          textSize: 12,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),
      ],
    );
  }
}
