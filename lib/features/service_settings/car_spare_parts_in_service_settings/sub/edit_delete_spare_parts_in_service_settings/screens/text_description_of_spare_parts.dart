import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class TextDescriptionOfSpareParts extends StatelessWidget {
  const TextDescriptionOfSpareParts({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text:
          'إطار عالي الجودة من شركة بريدجستون اليابانية، مصنوع في إيطاليا. يتميز بأداء ممتاز في الثبات والهدوء على الطرق، مناسب للاستخدام في الأجواء المصرية. خالي من أي تلف أو لحامات.',
      textSize: 16,
      fontWeightIndex: FontSelectionData.regularFontFamily,
      textColor: AppColors.blackColor,
    );
  }
}
