import 'package:flutter/cupertino.dart';
import '../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/data_column_of_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';

class FirstRowInDataContainerInListDataFirstScreenInternalOrders extends StatelessWidget {
  final void Function()? onTap;
  const FirstRowInDataContainerInListDataFirstScreenInternalOrders({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DataColumnOfFirstRowInDataContainerInListDataFirstScreenInternalOrders(),
        ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
          onTap: onTap,
        )
      ],
    );
  }
}
