import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/container_details_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/column_subscription_fees_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/column_packing_date_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/row_main_branch_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/row_name_emp_widget.dart';

class TabViewListDataContainerDesignNewOrderPetroleum extends StatelessWidget {
  const TabViewListDataContainerDesignNewOrderPetroleum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RowNameEmpWidget(),
        RowMainBranchWidget(),
        ColumnPackingDateWidget(),
        ColumnPackingDateWidget(
          title: 'التعبئة',
          subTitle: '2 لتر بنزين 95',
        ),
        ColumnSubscriptionFeesWidget(),
        ContainerDetailsWidget(),
      ],
    );
  }
}
