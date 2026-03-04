import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';

class SecondPartDataContainerInListDataFirstScreenInternalOrders
    extends StatefulWidget {
  const SecondPartDataContainerInListDataFirstScreenInternalOrders({
    super.key,
  });

  @override
  State<SecondPartDataContainerInListDataFirstScreenInternalOrders>
  createState() =>
      _SecondPartDataContainerInListDataFirstScreenInternalOrdersState();
}

class _SecondPartDataContainerInListDataFirstScreenInternalOrdersState extends State<SecondPartDataContainerInListDataFirstScreenInternalOrders> {

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
        ..loadInternalOrders(
          serviceId: MainCategoryConstants.maintenanceAndInternalServicesID
        ),
      child: BlocBuilder<GetProviderInternalOrderCubit,
          GetProviderInternalOrderState>(
        builder: (context, state) {
          if (state is GetProviderInternalOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetProviderInternalOrderSuccess) {
            final orders = state.orders;

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
                  pricePart6: order.totalPrice?.toString() ?? "0",
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
