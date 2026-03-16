import 'package:flutter/material.dart';
import 'package:sun_web_system/features/order_status_design/order_details_new_order_emp/screens/part_left_screen/container_contact_with_customer_order_details_new_order_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_new_order_emp/screens/part_left_screen/data_time_line_tile_order_details_new_order_emp.dart';
import 'package:sun_web_system/features/service_settings/first_screen_service_settings/screens/container_return_to_page_setting.dart';
import '../../../../../../../../core/language/language_constant.dart';


class DataPartLeftScreenOrderDetailsNewOrderEmp extends StatelessWidget {
  const DataPartLeftScreenOrderDetailsNewOrderEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        ContainerReturnToPageSetting(
          text: AppLanguageKeys.back,
          onTap: (){
              Navigator.pop(context);
          },
        ),
        const ContainerContactWithCustomerOrderDetailsNewOrderEmp(),
        const DataTimeLineTileOrderDetailsNewOrderEmp()
    ],
    );
  }
}