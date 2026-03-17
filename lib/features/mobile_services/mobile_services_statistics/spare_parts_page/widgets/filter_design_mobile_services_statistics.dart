import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/tabs_cubit/tabs_cubit.dart';
import 'package:sun_web_system/features/spare_parts/custom_widget/app_pagination.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../features/internal_services/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../../features/internal_services/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/internal_services/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';

class FilterDesignMobileServicesStatistics
    extends StatelessWidget {
  const FilterDesignMobileServicesStatistics({
    super.key,
  });

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return "${parsed.day}/${parsed.month}/${parsed.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProviderInternalOrderCubit,
        GetProviderInternalOrderState>(
      builder: (context, state) {
        if (state is GetProviderInternalOrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetProviderInternalOrderSuccess) {

          final selectedTab = context.watch<TabsCubit>().state;

          final allOrders = state.orders;

          List orders;

          switch (selectedTab) {
            case 1: // New Orders
              orders = allOrders
                  .where((o) =>
              o.orderStatus ==
                  OrderStatus.newOrderForProvider)
                  .toList();
              break;

            case 2: // Completed
              orders = allOrders
                  .where((o) =>
              o.orderStatus ==
                  OrderStatus.orderCompleted)
                  .toList();
              break;

            case 3: // Under Service
              orders = allOrders
                  .where((o) =>
              o.orderStatus ==
                  OrderStatus.workInProgress ||
                  o.orderStatus ==
                      OrderStatus.employeeInRoad)
                  .toList();
              break;

            default: // All
              orders = allOrders;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final service = order.services?.isNotEmpty == true
                        ? order.services!.first
                        : null;

                    final isEnglish =
                        Localizations.localeOf(context).languageCode == 'en';

                    final serviceTitle = isEnglish
                        ? (service?.latinName ?? "")
                        : (service?.name ?? "");

                    return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                      imagePathPart1: AppImageKeys.service33,
                      titlePart1: serviceTitle,
                      subTitlePart1: '',
                      imagePathPart2: AppImageKeys.car501,
                      textCarPart2: order.branchName ?? "",
                      titlePart2: order.providerName ?? "",
                      imagePathPart3: AppImageKeys.person22,
                      titlePart3: AppLanguageKeys.name,
                      subTitlePart3: order.username ?? "",
                      status: order.orderStatus,
                      timePart5: _formatDate(order.orderDate),
                      pricePart6: order.totalPrice?.toString() ?? "10",
                    );
                  },
                ),
              ),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: 50,
                onPageChanged: (page) {
                  context.read<GetProviderInternalOrderCubit>().loadInternalOrders(
                    serviceId: MainCategoryConstants.mobileServicesAndTransportationID,
                    pageNumber: page,
                  );
                },
              )
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
