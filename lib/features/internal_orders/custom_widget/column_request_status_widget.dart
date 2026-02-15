import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/internal_orders/custom_widget/container_of_column_request_status_widget.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class ColumnRequestStatusWidget extends StatelessWidget {
  final String? text;
  final double? textSizeContainer, textSize;
  final bool? isAccept,
      isReject,
      isNewOrder,
      isTruck,
      isPaidSuccess,
      isServiceProvider,
      isActive,
      isInActive,
      isWaitingForApproval;

  const ColumnRequestStatusWidget(
      {super.key,
      this.isAccept = false,
      this.isReject = false,
      this.isNewOrder = false,
      this.isTruck = false,
      this.isPaidSuccess = false,
      this.isServiceProvider = false,
      this.isActive = false,
      this.isInActive = false,
      this.isWaitingForApproval = false,
      this.text,
      this.textSizeContainer,
      this.textSize});

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
        ContainerOfColumnRequestStatusWidget(
          isReject: isReject,
          isAccept: isAccept,
          isNewOrder: isNewOrder,
          isTruck: isTruck,
          isServiceProvider: isServiceProvider,
          isPaidSuccess: isPaidSuccess,
          isActive: isActive,
          isInActive: isInActive,
          isWaitingForApproval: isWaitingForApproval,
          textSize: textSizeContainer,
        )
      ],
    );
  }
}
