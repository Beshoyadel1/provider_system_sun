import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/container_invoice_widget.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/title_with_sub_title_in_order_details_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_order_received_emp/screens/part_left_screen/container_contact_with_customer_order_details_order_received_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_order_received_emp/screens/part_left_screen/data_time_line_tile_order_details_order_received_emp.dart';

class DataContainerInListOrderDetailsOrderReceivedEmp extends StatelessWidget {
  const DataContainerInListOrderDetailsOrderReceivedEmp({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 950;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          const TitleWithSubTitleInOrderDetailsEmp(),
          const ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: 'car',
            subTitlePart1: 'car',
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'car',
            titlePart2: 'car' ,
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.name,
            subTitlePart3: 'car' ,
            timePart5: '3/11/555',
            pricePart6: '500' ,
            status: OrderStatus.orderCompleted,
          ),
          if(isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                ContainerContactWithCustomerOrderDetailsOrderReceivedEmp(),
                DataTimeLineTileOrderDetailsOrderReceivedEmp()
              ],
            ),
          const ContainerInvoiceWidget(
            priceInsuranceInstallment: '1000',
            priceTaxes: '00.00',
            priceTotal: '1000.00',
          ),
        ],
      ),
    );
  }
}
