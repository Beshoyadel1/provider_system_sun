import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../features/internal_orders/custom_widget/row_text_icon_orange.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class ColumnPriceOrderWidget extends StatelessWidget {
  final String price;

  const ColumnPriceOrderWidget({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.servicePrice,
          textSize: 11,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.greyColor,
        ),
        RowTextIconOrange(text: price, imagePath: AppImageKeys.coin),
      ],
    );
  }
}
