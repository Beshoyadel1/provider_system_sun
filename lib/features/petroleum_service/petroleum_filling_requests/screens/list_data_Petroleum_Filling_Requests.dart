import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_crave_digram_for_petroleum/design_crave_digram_for_petroleum.dart';
import '../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_digram_for_petroleum/design_digram_for_petroleum.dart';
import '../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/container_design_new_order_Petroleum.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';

class ListDataPetroleumFillingRequests extends StatelessWidget {
  const ListDataPetroleumFillingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if ((isMobile)) const DesignDigramForPetroleum(),
        const ContainerDesignNewOrderPetroleum(),
        if ((isMobile)) const DesignCraveDigramForPetroleum(),
      ],
    );
  }
}
