import 'package:flutter/cupertino.dart';
import '../../../../../../../features/rates/custom_widget/image_with_date_title_widget.dart';

class FirstRowContainerReviewDataPersonDesign extends StatelessWidget {
  final String imagePathPerson, date, textWithDate, imagePathRate;

  const FirstRowContainerReviewDataPersonDesign({
    super.key,
    required this.imagePathPerson,
    required this.date,
    required this.textWithDate,
    required this.imagePathRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10,
      children: [
        ImageWithDateTitleWidget(
          imagePath: imagePathPerson,
          date: date,
          text: textWithDate,
        ),
        Flexible(child: Image.asset(imagePathRate))
      ],
    );
  }
}
