import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../features/service_settings/custom_widget/button_edit_delete_setting_widget.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';

class FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings
    extends StatelessWidget {
  const FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTab = size.width > ValuesOfAllApp.mobileWidth + 70;
    return isTab
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(AppImageKeys.spare_parts2),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      TextInAppWidget(
                        text: 'أسم قطع غيار',
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                        textColor: AppColors.blackColor,
                      ),
                      TextInAppWidget(
                        text: 'اكسسوارات',
                        textSize: 14,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.orangeColor,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  ButtonEditDeleteSettingWidget(),
                  ButtonEditDeleteSettingWidget(
                    isDelete: true,
                  ),
                ],
              ),
            ],
          )
        : Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(AppImageKeys.spare_parts2),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      TextInAppWidget(
                        text: 'أسم قطع غيار',
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                        textColor: AppColors.blackColor,
                      ),
                      TextInAppWidget(
                        text: 'اكسسوارات',
                        textSize: 14,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.orangeColor,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(child: ButtonEditDeleteSettingWidget()),
                  Expanded(
                    child: ButtonEditDeleteSettingWidget(
                      isDelete: true,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
