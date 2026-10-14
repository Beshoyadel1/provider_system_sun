import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/text_styles.dart';

class TypeCar extends StatelessWidget {
  const TypeCar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      children: [
        Column(
          children: [
            // Image.asset(
            //   AppImageKeys.cr_v_car,
            //   width: 40,
            //   height: 20,
            //   fit: BoxFit.contain,
            // ),
             TextInAppWidget(
                text: AppLanguageKeys.ariya, textSize: 14, textColor: AppColors.darkColor),
          ],
        ),
         SizedBox(
          width: 10,
        ),
         TextInAppWidget(
            text: AppLanguageKeys.nissan, textSize: 14, textColor: AppColors.darkColor),
      ],
    );
  }
}
