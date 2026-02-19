import 'package:flutter/cupertino.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/container_review_data_person_design.dart';
import 'package:flutter/material.dart';

class MobileListDataContainerReviewDataPersonDesign extends StatelessWidget {
  const MobileListDataContainerReviewDataPersonDesign({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, double>> reviews = [
      {"rate": 5.0},
      {"rate": 4.0},
      {"rate": 5.0},
      {"rate": 4.0},
      {"rate": 0.0},
      {"rate": 0.0},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ContainerReviewDataPersonDesign(
          imagePathPerson: AppImageKeys.person22,
          date: '20/12/2020',
          textWithDate: 'مركز صيانة جيد',
          rate: reviews[index]["rate"],
          textReview:
          'خدمة ممتازة! طلبت فحص وصيانة للمكيف، ووصل الفني خلال أقل من ساعة. التعامل راقٍ،',
        );
      },
    );
  }
}
