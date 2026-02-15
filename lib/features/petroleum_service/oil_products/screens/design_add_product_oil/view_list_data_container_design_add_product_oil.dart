import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/mobile_view_list_data_container_design_add_product_oil.dart';
import '../../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/tab_view_list_data_container_design_add_product_oil.dart';

class ViewListDataContainerDesignAddProductOil extends StatelessWidget {
  final double? sizeTab, sizeCustomTab;

  const ViewListDataContainerDesignAddProductOil(
      {super.key, this.sizeCustomTab, this.sizeTab});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width <= (sizeCustomTab ?? 500);
    const int itemCount = 10;
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildCard(isMobile),
    );
  }
}

Widget _buildCard(bool isMobile) {
  final child = isMobile
      ? const MobileViewListDataContainerDesignAddProductOil()
      : const TabViewListDataContainerDesignAddProductOil();

  return child;
}
