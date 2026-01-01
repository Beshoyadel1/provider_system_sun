import 'package:flutter/material.dart';

import '../../../core/theming/assets.dart';
import '../../../core/theming/colors.dart';
import '../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../core/theming/text_styles.dart';

class CarModel extends StatelessWidget {
  const CarModel({super.key});

  @override
  Widget build(BuildContext context) {
    return   Wrap(
      spacing:5,
      children: [
        Image.asset(AppImageKeys.carHaraj, width: 65, height: 40, fit: BoxFit.contain,),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextInAppWidget(text:'2025', textSize: 14, textColor: AppColors.orangeColor),
            TextInAppWidget(text: 'BYD Electric', textSize: 14, textColor: AppColors.darkColor),
          ],
        )],
    );
  }
}
