import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_cubit.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_interior_services_statistics/FastLineWithFill.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_interior_services_statistics/first_row_in_data_in_container_interior_services_statistics.dart';

class DataInContainerInteriorServicesStatistics extends StatelessWidget {
  const DataInContainerInteriorServicesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
        return Column(
          children: [
            FirstRowInDataInContainerInteriorServicesStatistics(),
            state.isLoaded?FastLineWithFill():const SizedBox.shrink(),
          ],
        );
      }
    );
  }
}
