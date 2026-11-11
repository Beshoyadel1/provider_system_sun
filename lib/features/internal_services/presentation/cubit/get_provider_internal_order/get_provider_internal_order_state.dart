import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
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
    Future<GetProviderOrdersResponse> Function(
            {required GetProviderOrdersRequest getProviderOrdersRequest})?
        ordersLoader,
  })  : _updates = updates ?? NotificationUpdates.instance,
        _userLoader = userLoader ?? AuthLocalStorage.getUser,
        _ordersLoader = ordersLoader ?? getProviderOrdersFunction,
        super(GetProviderInternalOrderInitial()) {
    _subscription = _updates.stream.listen(_onNotification);
    _updates.registerOrderConsumer(this, _needsDetails);
  }

  final NotificationUpdates _updates;
  final Future<CreateUserRequest?> Function() _userLoader;
  final Future<GetProviderOrdersResponse> Function(
          {required GetProviderOrdersRequest getProviderOrdersRequest})
      _ordersLoader;
  StreamSubscription<NotificationPayload>? _subscription;
  int? _serviceId, _orderType;
  int? _branchId;
  int? _providerId;
  int _loadVersion = 0;
  int _pageNumber = 1;
  int? _employeeId;
  int _pageSize = 20;
  int? get selectedEmployeeId => _employeeId;
  int get pageSize => _pageSize;

  Future<void> applyServerFilters({int? employeeId, int? pageSize}) {
    _employeeId = employeeId;
    if (pageSize != null && pageSize > 0) _pageSize = pageSize;
    return loadInternalOrders(
        serviceId: _serviceId,
        branchId: _branchId,
        orderType: _orderType,
        pageNumber: 1);
  }

  Future<void> reload() => loadInternalOrders(
        orderType: _orderType,
        serviceId: _serviceId,
        branchId: _branchId,
        pageNumber: _pageNumber,
      );

  void _onNotification(NotificationPayload payload) {
    if (!payload.isOrder ||
        isClosed ||
        state is! GetProviderInternalOrderSuccess) {
      return;
    }
    if (_employeeId != null && payload.kind == NotificationKind.orderAssigned) {
      unawaited(reload());
      return;
    }
    final current = state as GetProviderInternalOrderSuccess;
    final id = payload.orderId;
    if (id == null || id <= 0) return;
    final patch = _updates.orders[id] ?? payload.orderPatch;
    if (!_matchesProvider(patch)) return;
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
    } else if (current.currentPage == 1 && _canInsert(patch)) {
      orders.insert(0, OrderModel().applyPatch(patch));
      if (orders.length > _pageSize) orders.removeLast();
      count++;
    } else {
      return;
    }
    final pageCount = count == current.totalCount
        ? current.pageCount
        : (count + _pageSize - 1) ~/ _pageSize;
    emit(GetProviderInternalOrderSuccess(orders,
        currentPage: current.currentPage,
        pageCount: pageCount,
        totalCount: count));
  }

  bool _canInsert(Map<String, dynamic> patch) {
    // A compact notification cannot establish employee assignment membership.
    if (_employeeId != null) return false;
    if (_branchId != null &&
        int.tryParse('${patch['branchid']}') != _branchId) {
      return false;
    }
    final status = int.tryParse('${patch['orderstatus']}');
    if (_orderType != null && (status == null || !_matchesOrderType(status))) {
      return false;
    }
    return _serviceId == null ||
        _serviceId == 0 ||
        _serviceIds(patch).contains(_serviceId);
  }

  bool _matchesProvider(Map<String, dynamic> patch) {
    final provider = int.tryParse('${patch['provid']}');
    return _providerId == null ||
        provider == null ||
        provider <= 0 ||
        provider == _providerId;
  }

  Set<int> _serviceIds(Map<String, dynamic> patch) {
    final services = patch['services'];
    return {
      if (int.tryParse('${patch['serviceid']}') case final int id) id,
      if (services is List)
        for (final service in services.whereType<Map>()) ...[
          if (int.tryParse('${service['id']}') case final int id) id,
          if (int.tryParse('${service['parentid']}') case final int id) id,
        ],
    };
  }

  bool _matchesOrderType(int status) {
    // Match the documented tab enum when a push moves an order between tabs.
    switch (_orderType) {
      case OrderType.New:
        return OrderType.newOrders.contains(status);
      case OrderType.current:
        return OrderType.currentOrders.contains(status);
      case OrderType.done:
        return OrderType.doneOrders.contains(status);
      default:
        return true;
    }
  }

  bool _needsDetails(NotificationPayload payload) {
    if (_employeeId != null) return false;
    if (!payload.isOrder ||
        payload.detailsRefreshed ||
        isClosed ||
        state is! GetProviderInternalOrderSuccess) {
      return false;
    }
    final current = state as GetProviderInternalOrderSuccess;
    if (current.currentPage != 1) return false;
    final patch = _updates.orders[payload.orderId] ?? payload.orderPatch;
    if (!_matchesProvider(patch)) return false;
    final status = int.tryParse('${patch['orderstatus']}');
    if (status != null && !_matchesOrderType(status)) return false;
    final branch = int.tryParse('${patch['branchid']}');
    if (_branchId != null && branch != null && branch != _branchId) {
      return false;
    }
    final services = patch['services'];
    if (_serviceId != null &&
        _serviceId != 0 &&
        services is List &&
        services.isNotEmpty &&
        !_serviceIds(patch).contains(_serviceId)) {
      return false;
    }
    final order =
        current.orders.where((o) => o.id == payload.orderId).firstOrNull;
    if (order == null) return true;
    return payload.kind == NotificationKind.newOrder &&
        (order.orderStatus == null ||
            order.username == null ||
            order.orderDate == null);
  }

  Future<void> loadInternalOrders({
    int? orderType,
    int? serviceId,
    int? pageNumber,
    int? branchId,
  }) async {
    if (isClosed) return;
    if ((_branchId ?? 0) != (branchId ?? 0) || _serviceId != serviceId) {
      _employeeId = null;
    }
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
          emit(const GetProviderInternalOrderError(
              AppLanguageKeys.userNotFound));
        }
        return;
      }

      final request = GetProviderOrdersRequest(
        providerId: user.userid,
        employeeId: _employeeId,
        pageSize: _pageSize,
        pageNumber: pageNumber ?? 1,
        orderType: orderType,
        serviceId: serviceId,
        branchId: _branchId,
      );
      _providerId = user.userid;
      if (kDebugMode) {
        debugPrint('[Orders] POST GetProviderOrders ${request.toJson()}');
      }
      final response = await _ordersLoader(
        getProviderOrdersRequest: request,
      );
      if (kDebugMode) {
        debugPrint(
            '[Orders] Received ${response.data.length} orders; total=${response.totalCount}');
      }

      if (!isClosed && version == _loadVersion) {
        emit(
          GetProviderInternalOrderSuccess(
            response.data
                .map((order) => order.applyPatch(
                    (_updates.orderVersions[order.id] ?? 0) >
                            notificationVersion
                        ? _updates.orders[order.id] ?? {}
                        : {}))
                .toList(),
            currentPage:
                response.currentPage > 0 ? response.currentPage : _pageNumber,
            pageCount: response.pageCount,
            totalCount: response.totalCount,
          ),
        );
        for (final event in List.of(_updates.orderEvents.values)) {
          if ((_updates.orderVersions[event.orderId] ?? 0) >
              notificationVersion) {
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
        emit(GetProviderInternalOrderError(
          e is DioException
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
