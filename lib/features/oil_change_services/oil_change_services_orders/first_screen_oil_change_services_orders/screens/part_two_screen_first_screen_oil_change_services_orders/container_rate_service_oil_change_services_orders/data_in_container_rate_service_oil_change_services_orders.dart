import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/features/oil_change_services/oil_change_services_orders/first_screen_oil_change_services_orders/screens/part_two_screen_first_screen_oil_change_services_orders/container_rate_service_oil_change_services_orders/first_row_in_data_in_container_rate_service_oil_change_services_orders.dart';
import 'package:sun_web_system/features/oil_change_services/oil_change_services_orders/first_screen_oil_change_services_orders/screens/part_two_screen_first_screen_oil_change_services_orders/container_rate_service_oil_change_services_orders/second_row_in_data_in_container_rate_service_oil_change_services_orders.dart';
import 'package:sun_web_system/features/spare_parts/spare_parts_orders/first_screen_spare_parts_orders/screens/part_two_screen_first_screen_spare_parts_orders/container_rate_service_spare_parts_orders/first_row_in_data_in_container_rate_service_spare_parts_orders.dart';
import 'package:sun_web_system/features/spare_parts/spare_parts_orders/first_screen_spare_parts_orders/screens/part_two_screen_first_screen_spare_parts_orders/container_rate_service_spare_parts_orders/second_row_in_data_in_container_rate_service_spare_parts_orders.dart';

class DataInContainerRateServiceOilChangeServicesOrders extends StatelessWidget {
  const DataInContainerRateServiceOilChangeServicesOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FirstRowInDataInContainerRateServiceOilChangeServicesOrders(),
        SecondRowInDataInContainerRateServiceOilChangeServicesOrders()
      ],
    );
  }
}
