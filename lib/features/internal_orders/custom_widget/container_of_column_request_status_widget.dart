import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class ContainerOfColumnRequestStatusWidget extends StatelessWidget {
  final bool? isAccept,
      isReject,
      isNewOrder,
      isTruck,
      isPaidSuccess,
      isServiceProvider,
      isActive,
      isInActive,
      isWaitingForApproval;
  final double? textSize;
  final String? textInSideContainer;

  const ContainerOfColumnRequestStatusWidget({
    super.key,
    this.isAccept = false,
    this.isReject = false,
    this.isNewOrder = false,
    this.isTruck = false,
    this.isPaidSuccess = false,
    this.isServiceProvider = false,
    this.isActive = false,
    this.isWaitingForApproval = false,
    this.isInActive = false,
    this.textSize,
    this.textInSideContainer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isNewOrder!
            ? AppColors.blackColor25
            : (isReject! || isInActive!)
                ? AppColors.partPinkMixColor.withOpacity(0.1)
                : (isAccept! ||
                        isPaidSuccess! ||
                        isServiceProvider! ||
                        isActive!)
                    ? AppColors.partGreenMixColor.withOpacity(0.1)
                    : isWaitingForApproval!
                        ? AppColors.yelloContainerLoadingColor.withOpacity(0.2)
                        : isTruck!
                            ? AppColors.lightGreenColor
                            : AppColors.pinkColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        spacing: 5,
        children: [
          Icon(
            isNewOrder!
                ? Icons.file_open_outlined
                : (isReject! || isInActive!)
                    ? Icons.close
                    : (isAccept! ||
                            isPaidSuccess! ||
                            isServiceProvider! ||
                            isActive!)
                        ? Icons.done
                        : isWaitingForApproval!
                            ? Icons.autorenew
                            : isTruck!
                                ? Icons.airport_shuttle_outlined
                                : Icons.settings,
            size: 15,
            color: isNewOrder!
                ? AppColors.blackColor44
                : (isReject! || isInActive!)
                    ? AppColors.redColor
                    : (isAccept! ||
                            isPaidSuccess! ||
                            isServiceProvider! ||
                            isActive!)
                        ? AppColors.greenColor
                        : isWaitingForApproval!
                            ? AppColors.yelloIconLoadingColor
                            : isTruck!
                                ? AppColors.blueColor
                                : AppColors.orangeColor,
          ),
          Expanded(
            child: TextInAppWidget(
              text: isNewOrder!
                  ? AppLanguageKeys.newRequest
                  : isReject!
                      ? AppLanguageKeys.requestRejected
                      : isAccept!
                          ? AppLanguageKeys.delivered
                          : isPaidSuccess!
                              ? AppLanguageKeys.paymentSuccessful
                              : isServiceProvider!
                                  ? AppLanguageKeys.serviceProvider
                                  : isActive!
                                      ? AppLanguageKeys.active
                                      : isInActive!
                                          ? AppLanguageKeys.inactive
                                          : isWaitingForApproval!
                                              ? AppLanguageKeys
                                                  .waitingForApproval
                                              : isTruck!
                                                  ? AppLanguageKeys.onTheWay
                                                  : AppLanguageKeys
                                                      .underService,
              textSize: textSize ?? 9,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: isNewOrder!
                  ? AppColors.blackColor44
                  : (isReject! || isInActive!)
                      ? AppColors.redColor
                      : (isAccept! ||
                              isPaidSuccess! ||
                              isServiceProvider! ||
                              isActive!)
                          ? AppColors.greenColor
                          : isWaitingForApproval!
                              ? AppColors.yelloTextLoadingColor
                              : isTruck!
                                  ? AppColors.blueColor
                                  : AppColors.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
