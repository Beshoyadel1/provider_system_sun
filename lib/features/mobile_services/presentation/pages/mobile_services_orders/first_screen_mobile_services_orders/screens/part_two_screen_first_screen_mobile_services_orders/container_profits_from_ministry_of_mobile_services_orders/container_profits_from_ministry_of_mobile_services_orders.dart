import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/mobile_services/mobile_services_orders/first_screen_mobile_services_orders/screens/part_two_screen_first_screen_mobile_services_orders/container_profits_from_ministry_of_mobile_services_orders/data_in_container_profits_from_ministry_of_mobile_services_orders.dart';
import '../../../../../../../../core/theming/colors.dart';

class ContainerProfitsFromMinistryOfSparePartsOrders extends StatelessWidget {
  const ContainerProfitsFromMinistryOfSparePartsOrders({super.key});

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
      child: const DataInContainerProfitsFromMinistryOfMobileServicesOrders(),
    );
  }
}
