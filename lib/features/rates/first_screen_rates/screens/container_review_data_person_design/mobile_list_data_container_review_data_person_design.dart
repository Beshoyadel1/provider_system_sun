import 'package:flutter/cupertino.dart';
import '../../../../../../../core/api_functions/rates/get_provider_details_rates_model/rate_item.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/container_review_data_person_design.dart';
import 'package:flutter/material.dart';

class MobileListDataContainerReviewDataPersonDesign extends StatelessWidget {
  final List<RateItem> rates;

  const MobileListDataContainerReviewDataPersonDesign({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: rates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ContainerReviewDataPersonDesign(
          imagePathPerson:
          rates[index].userImage ?? AppImageKeys.person22,
          date: rates[index].username ?? '',
          textWithDate: 'مركز صيانة جيد',
          rate: rates[index].rate ?? 0,
          textReview: rates[index].message ?? '',
        );
      },
    );
  }
}