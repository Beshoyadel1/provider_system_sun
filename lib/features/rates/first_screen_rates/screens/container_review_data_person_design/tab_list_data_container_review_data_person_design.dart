import 'package:flutter/cupertino.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/container_review_data_person_design.dart';

import 'package:flutter/material.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/container_review_data_person_design.dart';

import 'package:flutter/material.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/container_review_data_person_design.dart';

class TabListDataContainerReviewDataPersonDesign extends StatelessWidget {
  const TabListDataContainerReviewDataPersonDesign({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, double>> reviews = [
      {"rate": 5.0},
      {"rate": 4.0},
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
      itemCount: (reviews.length / 2).ceil(),
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final int firstIndex = index * 2;
        final int secondIndex = firstIndex + 1;

        return Row(
          spacing: 20,
          children: [
            Expanded(
              child: ContainerReviewDataPersonDesign(
                imagePathPerson: AppImageKeys.person22,
                date: '20/12/2020',
                textWithDate: 'مركز صيانة جيد',
                rate: reviews[firstIndex]["rate"],
                textReview:
                'خدمة ممتازة! طلبت فحص وصيانة للمكيف، ووصل الفني خلال أقل من ساعة.',
              ),
            ),

            if (secondIndex < reviews.length)
              Expanded(
                child: ContainerReviewDataPersonDesign(
                  imagePathPerson: AppImageKeys.person22,
                  date: '20/12/2020',
                  textWithDate: 'مركز صيانة جيد',
                  rate: reviews[secondIndex]["rate"],
                  textReview:
                  'خدمة ممتازة! طلبت فحص وصيانة للمكيف، ووصل الفني خلال أقل من ساعة.',
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        );
      },
    );
  }
}
