import 'package:flutter/cupertino.dart';
import '../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/data_container_design_list_add_product_oil.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerDesignListAddProductOil extends StatelessWidget {
  final void Function()? onTap;

  const ContainerDesignListAddProductOil({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DataContainerDesignListAddProductOil(),
    );
  }
}
