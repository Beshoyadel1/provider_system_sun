import 'package:flutter/cupertino.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/second_row_container_review_data_person_design.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/first_row_container_review_data_person_design.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerReviewDataPersonDesign extends StatelessWidget {
  final String imagePathPerson, date, textWithDate, imagePathRate, textReview;

  const ContainerReviewDataPersonDesign({
    super.key,
    required this.imagePathPerson,
    required this.date,
    required this.textWithDate,
    required this.imagePathRate,
    required this.textReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstRowContainerReviewDataPersonDesign(
            imagePathPerson: imagePathPerson,
            textWithDate: textWithDate,
            date: date,
            imagePathRate: imagePathRate,
          ),
          SecondRowContainerReviewDataPersonDesign(
            textReview: textReview,
          ),
        ],
      ),
    );
  }
}
