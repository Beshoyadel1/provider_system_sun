import 'package:flutter/material.dart';
import '../../../../../core/theming/assets.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/text_styles.dart';

class CarModel extends StatelessWidget {
  final String?releaseDate,description;
  const CarModel({super.key,this.releaseDate,this.description});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: [
        Image.asset(
          AppImageKeys.carHaraj,
          width: 65,
          height: 40,
          fit: BoxFit.contain,
        ),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextInAppWidget(text: releaseDate??'2025', textSize: 14, textColor: AppColors.orangeColor),
            TextInAppWidget(
                text: description??'BYD Electric',
                textSize: 14,
                textColor: AppColors.darkColor),
          ],
        )
      ],
    );
  }
}
