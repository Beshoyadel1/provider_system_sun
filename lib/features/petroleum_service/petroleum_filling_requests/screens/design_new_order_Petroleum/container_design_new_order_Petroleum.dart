import 'package:flutter/cupertino.dart';
import '../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/data_container_design_new_order_Petroleum.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerDesignNewOrderPetroleum extends StatelessWidget {
  final void Function()? onTap;

  const ContainerDesignNewOrderPetroleum({
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
      child: const DataContainerDesignNewOrderPetroleum(),
    );
  }
}
