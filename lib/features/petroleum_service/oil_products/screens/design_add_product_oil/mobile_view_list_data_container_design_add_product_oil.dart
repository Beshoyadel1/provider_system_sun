import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/design_product_oil_widget.dart';

class MobileViewListDataContainerDesignAddProductOil extends StatelessWidget {
  const MobileViewListDataContainerDesignAddProductOil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: DesignProductOilWidget()),
        Flexible(child: DesignProductOilWidget()),
      ],
    );
  }
}
