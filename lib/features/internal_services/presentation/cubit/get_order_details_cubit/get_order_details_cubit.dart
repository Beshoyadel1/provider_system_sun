import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/notifications/data/notification_updates.dart';
import 'package:sun_web_system/features/notifications/data/model/notification_payload.dart';
import '../../../../../../../features/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import '../../../../../../../features/internal_services/data/request/get_order_details_request/get_order_details_datasource.dart';
import '../../../../../../../features/internal_services/presentation/cubit/get_order_details_cubit/get_order_details_state.dart';

class GetOrderDetailsCubit
    extends Cubit<GetOrderDetailsState> {
  GetOrderDetailsCubit({
    required this.getOrderDetailsDatasource,
    NotificationUpdates? updates,
  }) : _updates = updates ?? NotificationUpdates.instance,
       super(GetOrderDetailsInitial()) {
    _subscription = _updates.stream.listen((payload) {
      if (payload.isOrder && payload.orderId == getOrderDetailsDatasource.orderId) {
        _applyPatch(payload.orderPatch);
      }
    });
  }

  final NotificationUpdates _updates;
  StreamSubscription<NotificationPayload>? _subscription;

  void _applyPatch(Map<String, dynamic> patch) {
    final current = orderDetails;
    if (current == null || isClosed) return;
    orderDetails = current.applyNotificationPatch(patch);
    emit(GetOrderDetailsSuccess(orderDetails: orderDetails!));
  }

  final GetOrderDetailsDatasource getOrderDetailsDatasource;

  OrderDetailsModel? orderDetails;

  Future<void> getOrderDetails({bool force = false}) async {
    emit(GetOrderDetailsLoading());

    try {
      final result = await _updates.getOrderDetails(getOrderDetailsDatasource.orderId, force: force);

      orderDetails = result;

      if (isClosed) return;

      emit(
        GetOrderDetailsSuccess(
          orderDetails: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        GetOrderDetailsError(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
