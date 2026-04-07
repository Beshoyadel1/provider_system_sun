import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/container_design_list_add_product_oil.dart';
import '../../../../../../../../features/Petroleum_Service/Oil_Products/screens/list_data_oil_products.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';

class OilProducts extends StatelessWidget {
  const OilProducts({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return const Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: ListDataOilProducts(),
            ),
          ),
        ));
  }
}
