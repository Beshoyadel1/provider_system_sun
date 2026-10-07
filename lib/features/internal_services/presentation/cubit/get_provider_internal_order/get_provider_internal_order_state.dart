import 'dart:async';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../data/response/get_provider_orders_response/get_provider_orders_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sun_web_system/features/notifications/data/notification_updates.dart';
import 'package:sun_web_system/features/notifications/data/model/notification_payload.dart';
import '../../../data/model/get_provider_orders_model/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../../core/theming/auth_local_storage.dart';
import '../../../../../../../features/internal_services/data/datasource/get_provider_orders_datasource/get_provider_orders_repository.dart';
import '../../../../../../../features/internal_services/data/request/get_provider_orders_request/get_provider_orders_request.dart';
import '../../../../../../../features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_cubit.dart';

class GetProviderInternalOrderCubit
    extends Cubit<GetProviderInternalOrderState> {

  GetProviderInternalOrderCubit({
    NotificationUpdates? updates,
    Future<CreateUserRequest?> Function()? userLoader,
    Future<GetProviderOrdersResponse> Function({required GetProviderOrdersRequest getProviderOrdersRequest})? ordersLoader,
  })
      : _updates = updates ?? NotificationUpdates.instance,
        _userLoader = userLoader ?? AuthLocalStorage.getUser,
        _ordersLoader = ordersLoader ?? getProviderOrdersFunction,
        super(GetProviderInternalOrderInitial()) {
    _subscription = _updates.stream.listen(_onNotification);
    _updates.registerOrderConsumer(this, _needsDetails);
  }

  final NotificationUpdates _updates;
  final Future<CreateUserRequest?> Function() _userLoader;
  final Future<GetProviderOrdersResponse> Function({required GetProviderOrdersRequest getProviderOrdersRequest}) _ordersLoader;
  StreamSubscription<NotificationPayload>? _subscription;
  int? _serviceId, _orderType;
  int? _branchId;
  int _loadVersion = 0;
  int _pageNumber = 1;

  Future<void> reload() => loadInternalOrders(
    orderType: _orderType,
    serviceId: _serviceId,
    branchId: _branchId,
    pageNumber: _pageNumber,
  );

  void _onNotification(NotificationPayload payload) {
    if (!payload.isOrder || isClosed || state is! GetProviderInternalOrderSuccess) return;
    final current = state as GetProviderInternalOrderSuccess;
    final id = payload.orderId;
    if (id == null) return;
    final orders = List<OrderModel>.from(current.orders);
    final index = orders.indexWhere((o) => o.id == id);
    var count = current.totalCount;
    if (index >= 0) {
      final order = orders[index].applyPatch(payload.orderPatch);
      if (order.orderStatus != null && !_matchesOrderType(order.orderStatus!)) {
        orders.removeAt(index);
        count = count > 0 ? count - 1 : 0;
      } else {
        orders[index] = order;
      }
    } else if (current.currentPage == 1 && _canInsert(payload)) {
      orders.insert(0, OrderModel().applyPatch(payload.orderPatch));
      count++;
    } else { return; }
    emit(GetProviderInternalOrderSuccess(orders,
      currentPage: current.currentPage, pageCount: current.pageCount, totalCount: count));
  }

  bool _canInsert(NotificationPayload payload) {
    final p = payload.orderPatch;
    // Never put an order in an unrelated branch/category or infer filter enums.
    if (_branchId != null && int.tryParse('${p['branchid']}') != _branchId) return false;
    final status = int.tryParse('${p['orderstatus']}');
    if (_orderType != null && (status == null || !_matchesOrderType(status))) return false;
    if (_serviceId != null && _serviceId != 0 &&
        payload.integer('serviceId') != _serviceId &&
        !(p['services'] is List && (p['services'] as List).whereType<Map>().any(
          (s) => int.tryParse('${s['id']}') == _serviceId ||
                 int.tryParse('${s['parentid']}') == _serviceId))) { return false; }
    return true;
  }

  bool _matchesOrderType(int status) {
    // Current backend guide: -2/-1/0 early, 1/2 active, 3/4 completed/cancelled.
    switch (_orderType) {
      case 1: return status <= 0;
      case 2: return status == 3 || status == 4;
      case 3: return status == 1 || status == 2;
      default: return true;
    }
  }

  bool _needsDetails(NotificationPayload payload) {
    if (!payload.isOrder || isClosed || state is! GetProviderInternalOrderSuccess) return false;
    final current = state as GetProviderInternalOrderSuccess;
    if (current.currentPage != 1 || current.orders.any((o) => o.id == payload.orderId)) return false;
    final p = payload.orderPatch;
    final status = int.tryParse('${p['orderstatus']}');
    if (status != null && !_matchesOrderType(status)) return false;
    final branch = int.tryParse('${p['branchid']}');
    if (_branchId != null && branch != null && branch != _branchId) return false;
    return (_branchId != null && branch == null) ||
        (_serviceId != null && _serviceId != 0 && p['services'] == null && payload.integer('serviceId') == null) ||
        (_orderType != null && status == null);
  }

  Future<void> loadInternalOrders({
    int? orderType,
    int? serviceId,
    int? pageNumber,
    int? branchId,
  }) async {
    if (isClosed) return;
    _serviceId = serviceId;
    _orderType = orderType;
    _branchId = branchId != null && branchId > 0 ? branchId : null;
    _pageNumber = pageNumber ?? 1;
    final version = ++_loadVersion;
    final notificationVersion = _updates.revision;

    if (!isClosed) {
      emit(GetProviderInternalOrderLoading());
    }

    try {
      final user = await _userLoader();

      if (isClosed || version != _loadVersion) return;
      if (user?.userid == null || user!.userid! <= 0) {
        if (!isClosed) {
          emit(const GetProviderInternalOrderError("User not found"));
        }
        return;
      }

      final request = GetProviderOrdersRequest(
          providerId: user.userid,
          pageNumber: pageNumber ?? 1,
          orderType: orderType,
          serviceId: serviceId,
          branchId: _branchId,
        );
      if (kDebugMode) debugPrint('[Orders] POST GetProviderOrders ${request.toJson()}');
      final response = await _ordersLoader(
        getProviderOrdersRequest: request,
      );
      if (kDebugMode) debugPrint('[Orders] Received ${response.data.length} orders; total=${response.totalCount}');

      if (!isClosed && version == _loadVersion) {
        emit(

          GetProviderInternalOrderSuccess(
            response.data.map((order) =>
                order.applyPatch((_updates.orderVersions[order.id] ?? 0) > notificationVersion
                    ? _updates.orders[order.id] ?? {} : {})).toList(),
            currentPage: response.currentPage,
            pageCount: response.pageCount,
            totalCount: response.totalCount,
          ),
        );
        for (final event in List.of(_updates.orderEvents.values)) {
          if ((_updates.orderVersions[event.orderId] ?? 0) > notificationVersion) {
            _onNotification(event);
            unawaited(_updates.enrichOrder(event).catchError((Object e) {
              debugPrint('Missing order fields: $e');
            }));
          }
        }
      }

    } catch (e) {
      if (kDebugMode) debugPrint('[Orders] Load failed: $e');
      if (!isClosed && version == _loadVersion) {
        emit(GetProviderInternalOrderError( e is DioException
            ? responseOfStatusCode(e.response?.statusCode)
            : e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _updates.unregisterOrderConsumer(this);
    _subscription?.cancel();
    return super.close();
  }
}
