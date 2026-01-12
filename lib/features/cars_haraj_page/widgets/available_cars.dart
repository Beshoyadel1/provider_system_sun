import 'package:flutter/material.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/assets.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../Internal_services_page/widgets/order_state.dart';
import 'car_model.dart';
import 'message_numbers.dart';

class AvailableCars extends StatelessWidget {
  const AvailableCars({super.key, this.spacing, required this.onTap});

  final double? spacing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Center(
        child: Wrap(
          spacing: spacing ?? 35,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            const TextInAppWidget(
                text: '1#', textSize: 16, textColor: AppColors.darkColor),
            const CarModel(),
            const OrderState(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  AppImageKeys.nesan,
                  width: 30,
                  height: 34,
                  fit: BoxFit.contain,
                ),
                const TextInAppWidget(
                    text: 'نيسان',
                    textSize: 14,
                    textColor: AppColors.darkColor),
              ],
            ),
            MessageNumbers(),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextInAppWidget(
                    text: 'سعر السيارة ',
                    textSize: 14,
                    textColor: AppColors.darkColor),
                TextInAppWidget(
                    text: AppLanguageKeys.priceKey,
                    textSize: 14,
                    textColor: AppColors.darkColor),
              ],
            ),
            CustomContainer(
              containerHeight: 32,
              containerWidth: 80,
              border: Border.all(color: AppColors.orangeColor),
              isSelected: true,
              onTap: onTap,
              padding: EdgeInsets.zero,
              typeWidget: const Center(
                child: TextInAppWidget(
                    text: AppLanguageKeys.detailsKey,
                    textSize: 14,
                    textColor: AppColors.orangeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
