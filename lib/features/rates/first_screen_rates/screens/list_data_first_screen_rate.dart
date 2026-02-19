import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/list_data_container_review_data_person_design.dart';
import '../../../../../../features/rates/first_screen_rates/screens/title_total_rate_in_list_data_first_screen_rate.dart';
import '../../../../../../features/rates/first_screen_rates/screens/list_container_all_rate_service/list_container_all_rate_service.dart';
import '../../../../../../features/rates/first_screen_rates/screens/first_title_in_list_data_first_screen_rate.dart';

class ListDataFirstScreenRate extends StatelessWidget {
  const ListDataFirstScreenRate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        FirstTitleInListDataFirstScreenRate(),
        ListContainerAllRateService(),
        TitleTotalRateInListDataFirstScreenRate(),
        ListDataContainerReviewDataPersonDesign()
      ],
    );
  }
}