import 'package:flutter/material.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/text_styles.dart';
import 'available_cars.dart';

class ListOfCars extends StatelessWidget {
  const ListOfCars({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return CustomContainer(
      containerWidth: isMobile ? double.infinity : 860,
      isSelected: false,
      onTap: () {},
      typeWidget: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInAppWidget(
                        text: 'قائمة السيارات',
                        textSize: 20,
                        textColor: AppColors.darkColor,
                      ),
                      TextInAppWidget(
                        text: 'قائمة مختصرة من السيارات المتاحه  ',
                        textSize: 16,
                        textColor: AppColors.darkGreyColor,
                      ),
                    ],
                  ),
                  CustomContainer(
                    containerHeight: 38,
                    containerWidth: 129,
                    isSelected: true,
                    onTap: () {},
                    containerColor: AppColors.orangeColor,
                    padding: EdgeInsets.zero,
                    typeWidget: const Center(
                      child: TextInAppWidget(
                        text: AppLanguageKeys.viewAllKey,
                        textSize: 16,
                        textColor: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...List.generate(
              4,
              (_) => AvailableCars(
                    onTap: () {},
                  )),
        ],
      ),
    );
  }
}
