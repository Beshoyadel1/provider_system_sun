import 'package:flutter/material.dart';
import 'package:sun_web_system/features/accounts_management/presentation/custom_widget/title_with_sub_title.dart';
import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class WidgetDesignListWarranty extends StatelessWidget {
  final int? warrantyId;
  final num? price;
  final int? durationTypeId;
  final int? durationValue;
  final VoidCallback? onTapSubscription;

  const WidgetDesignListWarranty({
    super.key,
    this.warrantyId,
    this.price,
    this.durationTypeId,
    this.durationValue,
    this.onTapSubscription,
  });

  @override
  Widget build(BuildContext context) {
    final durationType = DurationType.all.where(
          (type) => type.id == durationTypeId,
    );

    final String durationName = durationType.isNotEmpty
        ? durationType.first.name
        : AppLanguageKeys.unknownType;

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: 20,
        runSpacing: 15,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.identity,
              subTitle: warrantyId?.toString() ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.price,
              subTitle: '${price ?? 0}',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.durationType,
              subTitle: durationName,
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.durationValue,
              subTitle: '${durationValue ?? 0}',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================================================
          // SUBSCRIPTION BUTTON
          // =========================================================

          SizedBox(
            width: 120,
            child: InkWell(
              onTap: onTapSubscription,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius:  BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: TextInAppWidget(
                    text: AppLanguageKeys.subscription,
                    textSize: 12,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}