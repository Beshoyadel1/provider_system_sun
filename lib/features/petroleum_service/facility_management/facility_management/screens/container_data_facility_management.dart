import 'package:flutter/cupertino.dart';
import '../../../../../../../features/Petroleum_Service/Facility_Management/facility_management/screens/list_data_facility_management.dart';
import '../../../../../../../core/theming/colors.dart';

class ContainerDataFacilityManagement extends StatelessWidget {
  const ContainerDataFacilityManagement({
    super.key,
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
      child: const ListDataFacilityManagement(),
    );
  }
}
