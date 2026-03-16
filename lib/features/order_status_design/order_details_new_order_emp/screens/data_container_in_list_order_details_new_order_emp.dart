import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/container_sold.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/title_with_sub_title_in_order_details_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_new_order_emp/screens/part_left_screen/container_contact_with_customer_order_details_new_order_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_new_order_emp/screens/part_left_screen/data_time_line_tile_order_details_new_order_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_new_order_emp/sub/dialog_reject_order/dialog_reject_order.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';

class DataContainerInListOrderDetailsNewOrderEmp extends StatelessWidget {
  const DataContainerInListOrderDetailsNewOrderEmp({super.key});
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
            textCarPart2: 'car' ?? "",
            titlePart2: 'car' ?? "",
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.name,
            subTitlePart3: 'car' ?? "",
            timePart5: '3/11/555',
            pricePart6: '500' ?? "0",
            status: OrderStatus.newOrderForProvider,
          ),
          if(isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                 ContainerContactWithCustomerOrderDetailsNewOrderEmp(),
                DataTimeLineTileOrderDetailsNewOrderEmp()
              ],
            ),
          Row(
            spacing: 20,
            children: [
              ContainerSold(
                text: AppLanguageKeys.requestAccepted,
                backGroundColor: AppColors.greenColor,
                onTap:(){
                  // Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   NavigateToPageWidget(OrderReceivedEmp()),
                  // );
                },
              ),
              ContainerSold(
                text: AppLanguageKeys.rejectRequest,
                backGroundColor: AppColors.redColor,
                onTap:(){
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => const DialogRejectOrder(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
