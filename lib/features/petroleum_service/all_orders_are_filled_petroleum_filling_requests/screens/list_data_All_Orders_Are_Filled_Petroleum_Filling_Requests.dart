import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/Petroleum_Service/All_Orders_Are_Filled_Petroleum_Filling_Requests/screens/title_with_sub_title_in_all_orders.dart';
import '../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';

class ListDataAllOrdersAreFilledPetroleumFillingRequests
    extends StatelessWidget {
  const ListDataAllOrdersAreFilledPetroleumFillingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        TitleWithSubTitleInAllOrders(),
        ViewListDataContainerDesignNewOrderPetroleum(
          sizeTab: 1000,
          sizeCustomTab: 600,
        ),
      ],
    );
  }
}
