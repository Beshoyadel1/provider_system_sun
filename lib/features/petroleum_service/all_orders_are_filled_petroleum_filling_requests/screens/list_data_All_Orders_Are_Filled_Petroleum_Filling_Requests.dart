import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/features/cars_haraj_page/model/filter_orders_model/filter_orders_model.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/tabs_cubit/tabs_cubit.dart';
import 'package:sun_web_system/features/internal_services/internal_services_statistics/Internal_services_page/widgets/filters_tabs_widget.dart';
import '../../../../../../features/Petroleum_Service/All_Orders_Are_Filled_Petroleum_Filling_Requests/screens/title_with_sub_title_in_all_orders.dart';
import '../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';

class ListDataAllOrdersAreFilledPetroleumFillingRequests
    extends StatelessWidget {
  const ListDataAllOrdersAreFilledPetroleumFillingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocProvider(
        create: (_) => TabsCubit(),
        child: FiltersTabsWidget(
          filterOptions: filterOrders,
          serviceId: MainCategoryConstants.petrolMainID,
        ),
      ),
    );
  }
}
