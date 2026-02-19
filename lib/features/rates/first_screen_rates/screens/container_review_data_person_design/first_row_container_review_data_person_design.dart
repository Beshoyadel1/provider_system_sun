import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../../../../../../../features/rates/custom_widget/image_with_date_title_widget.dart';

import 'package:flutter/material.dart';
import '../../../../../../../features/rates/custom_widget/image_with_date_title_widget.dart';

class FirstRowContainerReviewDataPersonDesign extends StatelessWidget {
  final String imagePathPerson, date, textWithDate;
  final double? rate;

  const FirstRowContainerReviewDataPersonDesign({
    super.key,
    required this.imagePathPerson,
    required this.date,
    required this.textWithDate,
    this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final double currentRate = rate ?? 3.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ImageWithDateTitleWidget(
          imagePath: imagePathPerson,
          date: date,
          text: textWithDate,
        ),

        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < currentRate
                  ? Icons.star
                  : Icons.star_border,
              color: AppColors.brownColor,
              size: 20,
            );
          }),
        ),
      ],
    );
  }
}

