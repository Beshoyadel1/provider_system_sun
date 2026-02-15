import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/design_product_oil_widget.dart';

class TabViewListDataContainerDesignAddProductOil extends StatelessWidget {
  const TabViewListDataContainerDesignAddProductOil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DesignProductOilWidget(),
        DesignProductOilWidget(),
        DesignProductOilWidget(),
      ],
    );
  }
}
