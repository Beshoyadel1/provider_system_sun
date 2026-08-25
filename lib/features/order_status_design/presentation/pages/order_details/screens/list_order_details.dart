import 'package:flutter/material.dart';
import 'package:sun_web_system/features/order_status_design/presentation/cubit/order_status_cubit/order_status_cubit.dart';
import '../../../../../../../../features/internal_services/data/model/get_provider_orders_model/order_model.dart';
import '../../../../../../../../features/internal_services/presentation/cubit/get_order_details_cubit/get_order_details_state.dart';
import '../../../../../../../../features/order_status_design/presentation/custom_widget/data_time_line_tile_order_details_widget.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/container_contact_with_customer_order_details.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/design_bill_order.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/design_car_data_orders.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/design_notes_order.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/view_list_data_order.dart';
import '../../../../../../features/order_status_design/presentation/pages/order_details/screens/title_order_id_with_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/internal_services/data/request/get_order_details_request/get_order_details_datasource.dart';
import '../../../../../../../../features/internal_services/presentation/cubit/get_order_details_cubit/get_order_details_cubit.dart';

class ListOrderDetails extends StatelessWidget {
  final OrderModel order;

  const ListOrderDetails({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetOrderDetailsCubit(
            getOrderDetailsDatasource: GetOrderDetailsDatasource(
              orderId: order.id ?? 0,
            ),
          )..getOrderDetails(),
        ),

        BlocProvider(
          create: (_) => OrderStatusCubit(),
        ),
      ],
      child: BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
        builder: (context, state) {
          if (state is GetOrderDetailsLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is GetOrderDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is GetOrderDetailsSuccess) {
            final orderDetails = state.orderDetails;

            return LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;

                // ============================================================
                // DESKTOP
                // ============================================================

                if (width >= 1220) {
                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleOrderIdWithStats(
                        status: orderDetails.status ?? 0,
                        id: orderDetails.id.toString(),
                      ),

                      ViewListDataOrder(
                        orderDetailsModel: orderDetails,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DesignCarDataOrders(
                                      orderDetailsModel: orderDetails,
                                    ),

                                    Row(
                                      spacing: 10,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: DesignBillOrder(
                                            orderDetailsModel: orderDetails,
                                          ),
                                        ),
                                        Expanded(
                                          child: DesignNotesOrder(
                                            note: orderDetails.notes ?? "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: DataTimeLineTileOrderDetailsWidget(
                                  orderStatus: orderDetails.status,
                                ),
                              ),
                            ],
                          ),

                          ContainerContactWithCustomerOrderDetails(
                            orderDetailsModel: orderDetails,
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // ============================================================
                // CUSTOM PHONE / TABLET
                // 768 - 1219
                // ============================================================

                if (width >= 768) {
                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleOrderIdWithStats(
                        status: orderDetails.status ?? 0,
                        id: orderDetails.id.toString(),
                      ),

                      ViewListDataOrder(
                        orderDetailsModel: orderDetails,
                      ),

                      // Car
                      DesignCarDataOrders(
                        orderDetailsModel: orderDetails,
                      ),

                      // Timeline + Notes
                      Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                spacing: 10,
                                children: [
                                  DesignNotesOrder(
                                    note: orderDetails.notes ?? "",
                                  ),
                                  ContainerContactWithCustomerOrderDetails(
                                    orderDetailsModel: orderDetails,
                                  ),
                                ],
                              )
                          ),
                          Expanded(
                            child: DataTimeLineTileOrderDetailsWidget(
                              orderStatus: orderDetails.status,
                            ),
                          ),
                        ],
                      ),

                      // Contact


                      // Bill
                      DesignBillOrder(
                        orderDetailsModel: orderDetails,
                      ),
                    ],
                  );
                }

                // ============================================================
                // PHONE
                // < 768
                // ============================================================

                return Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleOrderIdWithStats(
                      status: orderDetails.status ?? 0,
                      id: orderDetails.id.toString(),
                    ),

                    ViewListDataOrder(
                      orderDetailsModel: orderDetails,
                    ),

                    // 1. Car
                    DesignCarDataOrders(
                      orderDetailsModel: orderDetails,
                    ),

                    // 2. Timeline
                    DataTimeLineTileOrderDetailsWidget(
                      orderStatus: orderDetails.status,
                    ),

                    // 3. Notes
                    DesignNotesOrder(
                      note: orderDetails.notes ?? "",
                    ),

                    // 4. Contact
                    ContainerContactWithCustomerOrderDetails(
                      orderDetailsModel: orderDetails,
                    ),

                    // 5. Bill
                    DesignBillOrder(
                      orderDetailsModel: orderDetails,
                    ),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}