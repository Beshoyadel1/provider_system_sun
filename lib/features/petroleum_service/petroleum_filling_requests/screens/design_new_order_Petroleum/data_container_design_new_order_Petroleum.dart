import 'package:flutter/cupertino.dart';
import '../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_new_order_Petroleum/view_list_data_container_design_new_order_Petroleum.dart';
import '../../../../../../../features/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';

class DataContainerDesignNewOrderPetroleum extends StatelessWidget {
  const DataContainerDesignNewOrderPetroleum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FirstRowInDataContainerInListDataFirstScreenInternalOrders(
            onTap: () {
              // Navigator.of(context).push(
              //   NavigateToPageWidget(AllOrdersAreFilledPetroleumFillingRequests()),
              // );
            },
          ),
          ViewListDataContainerDesignNewOrderPetroleum()
        ],
      ),
    );
  }
}
