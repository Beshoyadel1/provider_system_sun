import 'package:flutter/cupertino.dart';
import '../../../../../../../core/api_functions/rates/get_provider_details_rates_model/rate_item.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/mobile_list_data_container_review_data_person_design.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/tab_list_data_container_review_data_person_design.dart';
import '../../../../../../../core/utilies/map_of_all_app.dart';

class ListDataContainerReviewDataPersonDesign extends StatelessWidget {
  final List<RateItem> rates;

  const ListDataContainerReviewDataPersonDesign({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isCustomTabWidth =
        size.width > ValuesOfAllApp.customTabWidth;

    return isCustomTabWidth
        ? TabListDataContainerReviewDataPersonDesign(rates: rates)
        : MobileListDataContainerReviewDataPersonDesign(rates: rates);
  }
}