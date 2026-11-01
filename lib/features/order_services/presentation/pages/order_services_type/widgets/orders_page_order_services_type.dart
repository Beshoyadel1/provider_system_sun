import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/tabs_cubit/tabs_cubit.dart';
import '../../../../../../../../../features/order_services/presentation/pages/order_services_type/widgets/filters_tabs_widget_order_services_type.dart';
import '../../../../../../../core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import 'order_server_filters.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';

class OrdersPageMobileServicesStatistics extends StatelessWidget {
  final int serviceId, branchId;
  const OrdersPageMobileServicesStatistics(
      {super.key,
      required this.cubit,
      required this.serviceId,
      required this.branchId});

  final NewOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TabsCubit()),
        BlocProvider(
            create: (_) => GetProviderInternalOrderCubit()
              ..loadInternalOrders(serviceId: serviceId, branchId: branchId)),
      ],
      child: CustomContainer(
          isSelected: false,
          onTap: () {},
          typeWidget: Center(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderFiltersHeader(branchId: branchId),
                Expanded(
                  child: FiltersTabsWidgetOrderServicesType(
                      filterOptions: filterOrders,
                      serviceId: serviceId,
                      branchId: branchId),
                ),
                // Center(child: NumberIndicator())
              ],
            ),
          )),
    );
  }
}
