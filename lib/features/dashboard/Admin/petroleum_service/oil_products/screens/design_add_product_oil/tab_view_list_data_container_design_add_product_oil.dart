import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/dashboard/Admin/Petroleum_Service/custom_widget/design_product_oil_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';


class TabViewListDataContainerDesignAddProductOil extends StatelessWidget {
  const TabViewListDataContainerDesignAddProductOil({super.key,});
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DesignProductOilWidget(),
        DesignProductOilWidget(),
        DesignProductOilWidget(),
      ],
    );
  }
}
