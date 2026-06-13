import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/cubit/app_cubit/app_cubit.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_cubit.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_state.dart';
import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_rate_service/container_rate_service.dart';
import 'package:sun_web_system/features/order_services/presentation/pages/order_services_statistics/screens/big_container_of_new_order_services_statistics/container_new_order_in_list_data_first_screen_order_services_statistics.dart';
import 'package:sun_web_system/features/order_services/presentation/pages/order_services_statistics/screens/container_image_title_with_sub_title_order_services_statistics/first_row_with_two_container_image_and_two_text_order_services_statistics.dart';
import 'package:sun_web_system/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_order_services_statistics/container_order_services_statistics.dart';
import 'package:sun_web_system/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_profits_from_ministry_of_order_services_statistics/container_profits_from_ministry_of_order_services_statistics.dart';
import 'package:sun_web_system/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_rate_service_order_services_statistics/container_rate_order_services_statistics.dart';
import 'package:sun_web_system/features/spare_parts/presentation/pages/spare_parts_orders/first_screen_spare_parts_orders/screens/part_two_screen_first_screen_spare_parts_orders/container_profits_from_ministry_of_spare_parts_orders/container_profits_from_ministry_of_spare_parts_orders.dart';

class ListDataOrderServicesStatistics extends StatelessWidget {
  final int serviceId;
  const ListDataOrderServicesStatistics({super.key,required this.serviceId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobileCustom = size.width <= 720;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth+200&&
        size.width>720;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
      builder: (context, state) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FirstRowWithTwoContainerImageAndTwoTextOrderServicesStatistics(),
            ContainerNewOrderInListDataFirstScreenOrderServicesStatistics(
              onTap: () {
                AppCubit.get(context).navigateToPage(serviceId+10);
              },
              serviceId:serviceId,
            ),
            if ((isMobile&&!isMobileCustom))
              const Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(child: ContainerProfitsFromMinistryOfOrderServicesStatistics()),
                      Expanded(child: ContainerRateOrderServicesStatistics())
                    ],
                  ),
                  ContainerOrderServicesStatistics(),
                ],
              ),

            if ((!isMobile&&isMobileCustom))
              const Column(
                spacing: 10,
                children: [
                  ContainerProfitsFromMinistryOfOrderServicesStatistics(),
                  ContainerRateOrderServicesStatistics(),
                  ContainerOrderServicesStatistics(),
                ],
              ),
          ],
        );
      },
    );
  }
}
