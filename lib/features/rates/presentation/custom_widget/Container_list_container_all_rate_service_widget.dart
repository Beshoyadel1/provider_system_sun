import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class ContainerListContainerAllRateServiceWidget extends StatelessWidget {
  final String imagePath, title, subTitle;

  const ContainerListContainerAllRateServiceWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.blackColor25.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 8),

              Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInAppWidget(
                    text: title,
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                  TextInAppWidget(
                    text: subTitle,
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
