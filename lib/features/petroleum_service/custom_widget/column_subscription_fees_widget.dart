import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_text_icon_orange.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class ColumnSubscriptionFeesWidget extends StatelessWidget {
  final String? title, budget, imagePath;

  const ColumnSubscriptionFeesWidget(
      {super.key, this.title, this.budget, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: title ?? 'رسوم الاشتراك',
          textSize: 9,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greyColor,
        ),
        RowTextIconOrange(
          text: budget ?? '250.00',
          imagePath: imagePath ?? AppImageKeys.coin,
        )
      ],
    );
  }
}
