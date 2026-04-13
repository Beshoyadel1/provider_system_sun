import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/features/mobile_services/mobile_services_orders/first_screen_mobile_services_orders/screens/big_container_of_new_orders_mobile_services/data_container_in_list_data_first_screen_mobile_services_orders.dart';
import 'package:sun_web_system/features/oil_change_services/oil_change_services_orders/first_screen_oil_change_services_orders/screens/big_container_of_new_orders_oil_change_services/data_container_in_list_data_first_screen_oil_change_services_orders.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerNewOrderInListDataFirstScreenOilChangeServices extends StatelessWidget {
  final void Function()? onTap;

  const ContainerNewOrderInListDataFirstScreenOilChangeServices(
      {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DataContainerInListDataFirstScreenOilChangeServicesOrders(
        onTap: onTap,
      ),
    );
  }
}
