import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/order_funcations/order_functions.dart';
import 'package:sun_web_system/features/order_status_design/cubit/order_status_cubit/order_status_cubit.dart';
import 'package:sun_web_system/features/order_status_design/cubit/order_status_cubit/order_status_state.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../features/internal_services/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../features/internal_services/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/custom_tab_view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/mobile_view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/tab_view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../core/theming/colors.dart';

class ViewListDataContainerDesignNewOrderPetroleum extends StatelessWidget {
  final double? sizeTab, sizeCustomTab;

  const ViewListDataContainerDesignNewOrderPetroleum({
    super.key,
    this.sizeCustomTab,
    this.sizeTab,
  });



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
            GetProviderInternalOrderCubit()
              ..loadInternalOrders(
                serviceId: MainCategoryConstants
                    .petrolMainID,
              ),
          ),
          BlocProvider(
            create: (_) => OrderStatusCubit(),
          ),
        ],
        child: BlocListener<OrderStatusCubit, OrderStatusState>(
          listener: (context, state) {
            if (state is OrderStatusSuccess) {
              context.read<GetProviderInternalOrderCubit>().loadInternalOrders(
                serviceId:
                MainCategoryConstants.petrolMainID,
              );
            }
          },
          child: BlocBuilder<GetProviderInternalOrderCubit,
              GetProviderInternalOrderState>(
            builder: (context, state) {
              if (state is GetProviderInternalOrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetProviderInternalOrderSuccess) {
                final orders = state.orders;
                if (state.orders.isEmpty) {
                  return const Center(
                    child:  TextInAppWidget(
                      text: AppLanguageKeys.empty,
                      textSize: 15,
                      textColor: AppColors.greyColor,
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    final service = order.services?.isNotEmpty == true
                        ? order.services!.first
                        : null;

                    final serviceTitle = OrderFunctions.getServiceTitle(
                      context: context,
                      service: service,
                    );

                    return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                      imagePathPart1: service?.image,
                      titlePart1: serviceTitle,
                      subTitlePart1: '',
                      imagePathPart2: AppImageKeys.car501,
                      textCarPart2: order.branchName ?? "",
                      titlePart2: order.providerName ?? "",
                      imagePathPart3: order.providerImage,
                      titlePart3: AppLanguageKeys.name,
                      subTitlePart3: order.username ?? "",
                      status: order.orderStatus,
                      timePart5: OrderFunctions.formatDate(order.orderDate),
                      pricePart6: order.totalPrice?.toString() ?? "0",
                      order: order,
                      serviceId:MainCategoryConstants.maintenanceAndInternalServicesID,
                    );
                  },
                );
              }

              if (state is GetProviderInternalOrderError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        )
    );
  }
}

// Widget _buildCard(
//     bool isMobile,
//     bool isTabletCustom,
//     String? nameEmp,
//     String? date,
//     String? quantity,
//     String? price,
//     ) {
//   final child = isMobile
//       ? MobileViewListDataContainerDesignNewOrderPetroleum(
//     nameEmp: nameEmp,
//     date: date,
//     quantity: quantity,
//     price: price,
//   )
//       : isTabletCustom
//       ? CustomTabViewListDataContainerDesignNewOrderPetroleum(
//     nameEmp: nameEmp,
//     date: date,
//     quantity: quantity,
//     price: price,
//   )
//       : TabViewListDataContainerDesignNewOrderPetroleum(
//     nameEmp: nameEmp,
//     date: date,
//     quantity: quantity,
//     price: price,
//   );
//
//   return Container(
//     padding: const EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       color: AppColors.whiteColor,
//       borderRadius: const BorderRadius.all(Radius.circular(20)),
//       border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
//       boxShadow: [
//         BoxShadow(
//           color: AppColors.darkColor.withOpacity(0.1),
//           blurRadius: 4,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: child,
//   );
// }