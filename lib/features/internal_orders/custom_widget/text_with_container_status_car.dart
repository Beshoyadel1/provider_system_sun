import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/internal_orders/custom_widget/container_status.dart';
import 'package:sun_web_system/features/internal_orders/custom_widget/container_status_car.dart';
import '../../../../../../../../features/internal_orders/custom_widget/container_of_column_request_status_widget.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class TextWithContainerStatusCar extends StatelessWidget {
  final String? text;
  final double? textSizeContainer, textSize;
  final bool? isNew;
  final bool? isSold;

  const TextWithContainerStatusCar({
    super.key,
    this.isNew,
    this.isSold,
    this.text,
    this.textSizeContainer,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: text ?? AppLanguageKeys.requestStatus,
          textSize: textSize ?? 11,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.greyColor,
        ),
        ContainerStatusCar(
          isNew: isNew,
          isSold: isSold,
          textSize: textSizeContainer,
        )
      ],
    );
  }
}