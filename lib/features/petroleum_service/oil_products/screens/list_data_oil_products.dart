import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/container_design_list_add_product_oil.dart';
import '../../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/container_design_list_oil_products.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';

class ListDataOilProducts extends StatelessWidget {
  const ListDataOilProducts({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1360;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const ContainerDesignListOilProducts(),
        if ((isMobile)) const ContainerDesignListAddProductOil(),
      ],
    );
  }
}
