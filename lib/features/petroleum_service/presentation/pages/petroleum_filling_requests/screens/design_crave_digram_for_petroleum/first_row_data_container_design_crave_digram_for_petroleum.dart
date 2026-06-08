import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class FirstRowDataContainerDesignCraveDigramForPetroleum
    extends StatelessWidget {
  const FirstRowDataContainerDesignCraveDigramForPetroleum({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 20,
      children: [
         Flexible(
          child: TextInAppWidget(
            text: AppLanguageKeys.fillingOrdersSalesForAllBranches,
            textSize: 22,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),
        // RowNumberCoinWidget(
        //     numberText: '250', sizeText: 15, imageSrc: AppImageKeys.coin)
      ],
    );
  }
}
