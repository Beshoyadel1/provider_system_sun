import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/container_details_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/column_subscription_fees_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/column_packing_date_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/row_main_branch_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/row_name_emp_widget.dart';

class MobileViewListDataContainerDesignNewOrderPetroleum
    extends StatelessWidget {
  const MobileViewListDataContainerDesignNewOrderPetroleum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RowNameEmpWidget(),
            RowMainBranchWidget(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColumnPackingDateWidget(),
            ColumnPackingDateWidget(
              title: 'التعبئة',
              subTitle: '2 لتر بنزين 95',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColumnSubscriptionFeesWidget(),
            ContainerDetailsWidget(),
          ],
        ),
      ],
    );
  }
}
