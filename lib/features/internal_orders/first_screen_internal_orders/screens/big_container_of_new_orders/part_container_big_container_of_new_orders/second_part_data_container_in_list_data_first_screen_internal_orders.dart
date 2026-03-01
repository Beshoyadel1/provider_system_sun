import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/api_functions/order/get_provider_orders_model/order_model.dart';
import '../../../../../../features/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';

class SecondPartDataContainerInListDataFirstScreenInternalOrders
    extends StatelessWidget {
  const SecondPartDataContainerInListDataFirstScreenInternalOrders({
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
    return BlocProvider(
      create: (_) => GetProviderInternalOrderCubit()
        ..getProviderInternalOrders(
          providerId: 5,
          serviceId: 5,
        ),
      child: BlocBuilder<GetProviderInternalOrderCubit,
          GetProviderInternalOrderState>(
        builder: (context, state) {
          if (state is GetProviderInternalOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetProviderInternalOrderSuccess) {
            final List<OrderModel> orders = state.orders;
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

                final isEnglish = Localizations.localeOf(context).languageCode == 'en';

                final serviceTitle = isEnglish
                    ? (service?.latinName ?? "")
                    : (service?.name ?? "");

                return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                  imagePathPart1: AppImageKeys.service33,
                  titlePart1: serviceTitle,
                  subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
                  imagePathPart2: AppImageKeys.car501,
                  textCarPart2: order.branchName ?? "",
                  titlePart2: order.providerName ?? "",
                  imagePathPart3: AppImageKeys.person22,
                  titlePart3: AppLanguageKeys.jobName,
                  subTitlePart3: order.username ?? "",
                  isNewOrderPart4: order.orderStatus == OrderType.New,
                  isAcceptPart4: order.orderStatus == OrderType.current,
                  isRejectPart4: order.orderStatus == OrderType.done,
                  timePart5: _formatDate(order.orderDate),
                  pricePart6: order.totalPrice?.toString() ?? "10",
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
