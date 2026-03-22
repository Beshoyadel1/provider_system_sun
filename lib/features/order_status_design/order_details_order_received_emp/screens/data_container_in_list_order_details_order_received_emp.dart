import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/Column_date_order_with_time_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/column_price_order_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/container_details_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/row_image_with_title_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/text_with_container_status.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/container_invoice_widget.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/title_with_sub_title_in_order_details_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_order_received_emp/screens/part_left_screen/container_contact_with_customer_order_details_order_received_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_order_received_emp/screens/part_left_screen/data_time_line_tile_order_details_order_received_emp.dart';
import 'package:sun_web_system/features/service_settings/first_screen_service_settings/screens/container_return_to_page_setting.dart';

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
          if(isMobile)
            ContainerReturnToPageSetting(
              text: AppLanguageKeys.back,
              onTap: (){
                Navigator.pop(context);
              },
            ),
          const TitleWithSubTitleInOrderDetailsEmp(),
          CustomContainer(
            isSelected: false,
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            typeWidget: const Wrap(
              spacing:35,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                RowImageWithTitleWidget(
                  title: 'car',
                  textSizeTitle: 12,
                  subTitle: 'car',
                  isWrap: true,
                ),
                RowImageWithTitleWidget(
                  isJob: true,
                  title: 'car',
                  subTitle: 'car',
                  isWrap: true,
                ),
                TextWithContainerStatus(
                  status: OrderStatus.orderCompleted,
                ),

                ColumnDateOrderWithTimeWidget(
                  time: '3/11/555',
                ),

                ColumnPriceOrderWidget(
                  price: '540',
                ),

              ],
            ),
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
