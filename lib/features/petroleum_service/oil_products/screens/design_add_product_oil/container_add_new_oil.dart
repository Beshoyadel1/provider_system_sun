import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerAddNewOil extends StatelessWidget {
  const ContainerAddNewOil({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.orangeColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.add,
            color: AppColors.whiteColor,
            size: 15,
          ),
          TextInAppWidget(
            text: AppLanguageKeys.addNewOil,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
