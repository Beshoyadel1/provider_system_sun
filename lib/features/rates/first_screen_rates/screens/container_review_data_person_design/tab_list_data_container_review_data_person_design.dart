import 'package:flutter/cupertino.dart';
import '../../../../../../../core/api_functions/rates/get_provider_details_rates_model/rate_item.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/container_review_data_person_design.dart';
import 'package:flutter/material.dart';

class TabListDataContainerReviewDataPersonDesign extends StatelessWidget {
  final List<RateItem> rates;

  const TabListDataContainerReviewDataPersonDesign({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: (rates.length / 2).ceil(),
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final int firstIndex = index * 2;
        final int secondIndex = firstIndex + 1;

        return Row(
          children: [
            Expanded(
              child: ContainerReviewDataPersonDesign(
                imagePathPerson:
                rates[firstIndex].userImage ?? AppImageKeys.person22,
                date: rates[firstIndex].username ?? '',
                textWithDate: 'مركز صيانة جيد',
                rate: rates[firstIndex].rate ?? 0,
                textReview: rates[firstIndex].message ?? '',
              ),
            ),
            const SizedBox(width: 20),
            if (secondIndex < rates.length)
              Expanded(
                child: ContainerReviewDataPersonDesign(
                  imagePathPerson:
                  rates[secondIndex].userImage ?? AppImageKeys.person22,
                  date: rates[secondIndex].username ?? '',
                  textWithDate: 'مركز صيانة جيد',
                  rate: rates[secondIndex].rate ?? 0,
                  textReview: rates[secondIndex].message ?? '',
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