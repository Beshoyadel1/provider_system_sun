import 'package:flutter/cupertino.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../core/language/language_constant.dart';

class FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettings
    extends StatefulWidget {
  const FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettings(
      {super.key});

  @override
  State<FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettings>
      createState() =>
          _FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettingsState();
}

class _FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettingsState
    extends State<
        FirstTitleSearchInDataSecondContainerInFirstScreenCarModelSettings> {
  late TextEditingController textFormController;

  @override
  void initState() {
    super.initState();
    textFormController = TextEditingController();
  }

  @override
  void dispose() {
    textFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.chooseYourCarModel,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greyColor,
        ),
        TextFormFieldWidget(
          prefixIcon: AppImageKeys.search2,
          textFormController: textFormController,
          fillColor: AppColors.transparent,
          borderColor: AppColors.darkColor.withOpacity(0.2),
          hintText: AppLanguageKeys.searchCarModel,
          hintTextSize: 11,
          hintTextColor: AppColors.darkColor.withOpacity(0.4),
          textSize: 11,
          contentPadding: const EdgeInsets.all(5),
          textFormHeight: 35,
          textFormWidth: 250,
        ),
      ],
    );
  }
}
