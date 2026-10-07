import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/notifications/data/notification_updates.dart';
import 'package:sun_web_system/features/notifications/data/model/notification_payload.dart';
import '../../../../../../../../../features/order_status_design/data/datasource/update_order_status_datasource/update_order_status_repository.dart';
import '../../../../../../../../../features/order_status_design/data/request/update_order_status_request.dart';
import '../../../../../../../../../features/order_status_design/presentation/cubit/order_status_cubit/order_status_state.dart';

class OrderStatusCubit extends Cubit<OrderStatusState> {
  OrderStatusCubit({
    Future<CreateUserRequest?> Function()? userLoader,
    Future<bool> Function(
            {required UpdateOrderStatusRequest updateOrderStatusRequest})?
        statusWriter,
    NotificationUpdates? updates,
  })  : _userLoader = userLoader ?? AuthLocalStorage.getUser,
        _statusWriter = statusWriter ?? updateOrderStatusFunction,
        _updates = updates ?? NotificationUpdates.instance,
        super(OrderStatusInitial());

  final Future<CreateUserRequest?> Function() _userLoader;
  final Future<bool> Function(
          {required UpdateOrderStatusRequest updateOrderStatusRequest})
      _statusWriter;
  final NotificationUpdates _updates;

  Future<void> updateOrderStatus({
    required int orderId,
    required int status,
  }) async {
    if (isClosed || state is OrderStatusLoading) return;
    emit(OrderStatusLoading());
    try {
      final user = await _userLoader();
      if (user?.userid == null || user!.userid! <= 0 || user.type == null) {
        throw Exception('Please sign in again');
      }
      if (orderId <= 0) throw Exception('Invalid order ID');
      final request = UpdateOrderStatusRequest(
        orderId: orderId,
        status: status,
        changedById: user.userid!,
        changedByType: user.type!,
      );
      final isSuccess = await _statusWriter(updateOrderStatusRequest: request);
      if (isClosed) return;
      if (!isSuccess) throw Exception('Failed to update order status');
      _updates.add(NotificationPayload({
        'type': 'update_order_status',
        'orderId': orderId,
        'status': status,
      }));
      emit(OrderStatusSuccess());
    } catch (e) {
      if (!isClosed) {
        emit(OrderStatusError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }
}
