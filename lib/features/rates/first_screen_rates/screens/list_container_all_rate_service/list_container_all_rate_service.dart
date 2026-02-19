import 'package:flutter/cupertino.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/list_container_all_rate_service/mobile_list_container_all_rate_service.dart';
import '../../../../../../../features/rates/first_screen_rates/screens/list_container_all_rate_service/tab_list_container_all_rate_service.dart';

class ListContainerAllRateService extends StatelessWidget {
  const ListContainerAllRateService({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width > 500 && size.width <= 1045;
    bool isTab = size.width > 1045;
    return isTab
        ? const TabListContainerAllRateService()
        : const MobileListContainerAllRateService();
  }
}
