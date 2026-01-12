import 'package:flutter/cupertino.dart';
import '../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/data_container_design_list_oil_products.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerDesignListOilProducts extends StatelessWidget {
  final void Function()? onTap;

  const ContainerDesignListOilProducts({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
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
      child: const DataContainerDesignListOilProducts(),
    );
  }
}
