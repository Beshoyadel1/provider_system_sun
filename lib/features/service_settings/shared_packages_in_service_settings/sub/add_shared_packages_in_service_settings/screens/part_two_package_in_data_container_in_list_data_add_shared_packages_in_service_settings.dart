import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../features/permissions/custom_widget/check_box_with_text_widget.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../core/language/language_constant.dart';

class PartTwoPackageInDataContainerInListDataAddSharedPackagesInServiceSettings
    extends StatelessWidget {
  const PartTwoPackageInDataContainerInListDataAddSharedPackagesInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.servicesIncluded,
          textSize: 16,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        Row(
          spacing: 5,
          children: [
            CheckBoxWithText(
              text: AppLanguageKeys.batteries,
              imageSelect: AppImageKeys.test50,
            ),
            CheckBoxWithText(
              text: AppLanguageKeys.maintenanceServices,
              imageSelect: AppImageKeys.service33,
            ),
            CheckBoxWithText(
              text: AppLanguageKeys.tires,
              imageSelect: AppImageKeys.tires1,
            ),
          ],
        ),
        Row(
          spacing: 5,
          children: [
            CheckBoxWithText(
              text: AppLanguageKeys.cleaningAndWashing,
              imageSelect: AppImageKeys.service01,
            ),
            CheckBoxWithText(
              text: AppLanguageKeys.glass,
              imageSelect: AppImageKeys.glass2,
            ),
            CheckBoxWithText(
              text: AppLanguageKeys.tires,
              imageSelect: AppImageKeys.tires1,
            ),
          ],
        )
      ],
    );
  }
}
