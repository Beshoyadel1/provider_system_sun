import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/accounts_management/presentation/custom_widget/title_with_sub_title.dart';

class CustomViewAllEmployeeListWidget extends StatelessWidget {
  const CustomViewAllEmployeeListWidget({
    super.key,
    this.id,
    this.nameEmployee,
    this.phone,
    this.email,
    this.isActive,
    this.onTapDetails,
    this.nameButton,
    this.spacing,
  });

  final String? id;
  final String? nameEmployee;
  final String? phone;
  final String? email;
  final bool? isActive;
  final String? nameButton;

  final double? spacing;

  final VoidCallback? onTapDetails;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),

      // =========================================================
      // MAIN CONTENT
      // =========================================================

      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,

        children: [

          // =====================================================
          // ID
          // =====================================================

          SizedBox(
            width: 120,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.identity,
              subTitle: id ?? "#1",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =====================================================
          // NAME
          // =====================================================

          SizedBox(
            width: 250,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.name,
              subTitle: nameEmployee ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =====================================================
          // PHONE
          // =====================================================

          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.phoneNumber,
              subTitle: phone ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =====================================================
          // EMAIL
          // =====================================================

          SizedBox(
            width: 250,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.email,
              subTitle: email ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =====================================================
          // STATUS
          // =====================================================

          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const TextInAppWidget(
                  text: AppLanguageKeys.status,
                  textSize: 12,
                  fontWeightIndex:
                  FontSelectionData.mediumFontFamily,
                  textColor: AppColors.greyColor,
                ),

                const SizedBox(height: 5),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: isActive == true
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: TextInAppWidget(
                    text: isActive == true
                        ? AppLanguageKeys.active
                        : AppLanguageKeys.inactive,

                    textSize: 12,

                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,

                    textColor: isActive == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // DETAILS BUTTON
          // =====================================================

          SizedBox(
            width: 110,
            child: InkWell(
              onTap: onTapDetails,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: AppColors.whiteColor,

                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),

                  border: Border.all(
                    color: AppColors.orangeColor,
                  ),
                ),

                child: Center(
                  child: TextInAppWidget(
                    text: nameButton ??
                        AppLanguageKeys.details,

                    textSize: 12,

                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,

                    textColor:
                    AppColors.orangeColor,
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