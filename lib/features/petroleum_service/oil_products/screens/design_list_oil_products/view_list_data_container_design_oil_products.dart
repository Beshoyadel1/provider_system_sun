import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/mobile_view_list_data_container_design_oil_products.dart';
import '../../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/tab_view_list_data_container_design_oil_products.dart';
import '../../../../../../../../core/theming/colors.dart';

class ViewListDataContainerDesignOilProducts extends StatelessWidget {
  final double? sizeTab, sizeCustomTab;

  const ViewListDataContainerDesignOilProducts(
      {super.key, this.sizeCustomTab, this.sizeTab});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width <= (sizeCustomTab ?? 1120);
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
      ? const MobileViewListDataContainerDesignOilProducts()
      : const TabViewListDataContainerDesignOilProducts();

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: AppColors.darkColor.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}
