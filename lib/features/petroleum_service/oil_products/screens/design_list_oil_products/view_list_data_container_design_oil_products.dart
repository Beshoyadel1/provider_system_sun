import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/mobile_view_list_data_container_design_oil_products.dart';
import '../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/tab_view_list_data_container_design_oil_products.dart';
import '../../../../../core/theming/colors.dart';

class ViewListDataContainerDesignOilProducts extends StatelessWidget {
  final double? sizeTab, sizeCustomTab;

  const ViewListDataContainerDesignOilProducts({
    super.key,
    this.sizeCustomTab,
    this.sizeTab,
  });

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return "${parsed.day}/${parsed.month}/${parsed.year}";
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width <= (sizeCustomTab ?? 1120);

    return BlocProvider(
      create: (_) => GetProviderInternalOrderCubit()
        ..loadInternalOrders(
          serviceId: CategoryConstants.oilsAndLubricants,
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
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
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

                return _buildCard(
                  isMobile,
                  order.id.toString(),
                  serviceTitle,
                  formatDate(order.orderDate),
                  order.totalPrice?.toString(),
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

Widget _buildCard(
    bool isMobile, String? id, String? name, String? date, String? budget) {
  final child = isMobile
      ? MobileViewListDataContainerDesignOilProducts(
          date: date,
          budget: budget,
          id: id,
          name: name,
        )
      : TabViewListDataContainerDesignOilProducts(
          date: date,
          budget: budget,
          id: id,
          name: name,
        );

  return Container(
    padding: const EdgeInsets.all(10),
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
    child: child,
  );
}
