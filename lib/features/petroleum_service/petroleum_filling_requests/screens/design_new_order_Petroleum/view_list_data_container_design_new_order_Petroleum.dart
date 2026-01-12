import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/custom_tab_view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/mobile_view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/tab_view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../../../../core/theming/colors.dart';

class ViewListDataContainerDesignNewOrderPetroleum extends StatelessWidget {
  final double? sizeTab, sizeCustomTab;

  const ViewListDataContainerDesignNewOrderPetroleum(
      {super.key, this.sizeCustomTab, this.sizeTab});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width <= (sizeCustomTab ?? 1045);
    final bool isTabletCustom =
        size.width > (sizeCustomTab ?? 1000) && size.width <= (sizeTab ?? 1450);

    const int itemCount = 10;

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildCard(isMobile, isTabletCustom),
    );
  }
}

Widget _buildCard(bool isMobile, bool isTabletCustom) {
  final child = isMobile
      ? const MobileViewListDataContainerDesignNewOrderPetroleum()
      : isTabletCustom
          ? const CustomTabViewListDataContainerDesignNewOrderPetroleum()
          : const TabViewListDataContainerDesignNewOrderPetroleum();

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
