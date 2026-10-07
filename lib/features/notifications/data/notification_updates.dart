import 'dart:async';
import 'model/notification_payload.dart';
import '../../internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import '../../internal_services/data/datasource/get_order_details_datasource/get_order_details_datasource.dart';
import '../../internal_services/data/request/get_order_details_request/get_order_details_datasource.dart';

typedef OrderDetailLoader = Future<OrderDetailsModel> Function(
    {required GetOrderDetailsDatasource getOrderDetailsDatasource});

/// Shares patches with mounted lists and retains them for a screen opened later.
class NotificationUpdates {
  NotificationUpdates({OrderDetailLoader? detailLoader})
      : _detailLoader = detailLoader ?? getOrderDetailsFunction;
  static final instance = NotificationUpdates();

  final _controller =
      StreamController<NotificationPayload>.broadcast(sync: true);
  final Map<int, Map<String, dynamic>> orders = {};
  final Map<int, NotificationPayload> orderEvents = {};
  final Map<int, int> orderVersions = {};
  int revision = 0;
  final Map<int, Map<String, dynamic>> serviceRequests = {};
  final OrderDetailLoader _detailLoader;
  final Map<int, OrderDetailsModel> _details = {};
  final Map<int, Future<OrderDetailsModel>> _detailRequests = {};
  final Map<int, Map<String, dynamic>> _pendingDetailPatches = {};
  final Map<Object, bool Function(NotificationPayload)> _orderConsumers = {};
  int _session = 0;
  Stream<NotificationPayload> get stream => _controller.stream;

  void registerOrderConsumer(
      Object owner, bool Function(NotificationPayload) needsDetails) {
    _orderConsumers[owner] = needsDetails;
  }

  void unregisterOrderConsumer(Object owner) => _orderConsumers.remove(owner);
  bool needsOrderDetails(NotificationPayload payload) =>
      _orderConsumers.values.any((test) => test(payload));

  Future<OrderDetailsModel> getOrderDetails(int id,
      {bool force = false}) async {
    if (_detailRequests[id] != null) return _detailRequests[id]!;
    if (!force && _details[id] != null) return _details[id]!;
    final session = _session;
    _pendingDetailPatches[id] = {};
    final pending = () async {
      var result = await _detailLoader(
          getOrderDetailsDatasource: GetOrderDetailsDatasource(orderId: id));
      if (session == _session) {
        // Only patches arriving after the request began override the fresh response.
        final after = orders[id] ?? {};
        final changes = _pendingDetailPatches[id] ?? <String, dynamic>{};
        result = result.applyNotificationPatch(changes);
        _details[id] = result;
        // Fresh API fields supersede older patches.
        orders[id] = {
          ...after,
          'status': result.status,
          'orderstatus': result.status
        };
      }
      return result;
    }();
    _detailRequests[id] = pending;
    try {
      return await pending;
    } finally {
      if (session == _session) {
        _detailRequests.remove(id);
        _pendingDetailPatches.remove(id);
      }
    }
  }

  Future<void> enrichOrder(NotificationPayload payload) async {
    final id = payload.orderId;
    if (id == null || !needsOrderDetails(payload)) return;
    final session = _session;
    final details = await getOrderDetails(id);
    if (session != _session) return;
    final patch = {
      'id': id,
      'branchid': details.branchid,
      'status': details.status,
      'orderstatus': details.status,
      'userid': details.userid,
      'usertype': details.usertype,
      'username': details.user?.username,
      'totalprice': details.totalprice,
      'orderdate': details.date?.toIso8601String(),
      'provid': details.provid,
      'services': [
        for (final s in details.services ?? <Service>[])
          {
            'id': s.id,
            'parentid': s.parentid,
            'name': s.name,
            'latinname': s.latinname
          }
      ],
      ...?orders[id],
    }..removeWhere((_, value) => value == null);
    add(NotificationPayload({
      ...payload.data,
      'orderInfo': patch,
      if (patch['status'] != null) 'status': patch['status']
    },
        title: payload.title,
        body: payload.body,
        messageId: payload.messageId,
        sentAt: payload.sentAt));
  }

  void add(NotificationPayload payload) {
    final id = payload.orderId;
    if (payload.isOrder && id != null && id > 0) {
      orderEvents[id] = payload;
      orderVersions[id] = ++revision;
      orders[id] = {...?orders[id], ...payload.orderPatch};
      if (_pendingDetailPatches.containsKey(id)) {
        _pendingDetailPatches[id] = {
          ..._pendingDetailPatches[id]!,
          ...payload.orderPatch
        };
      }
      if (_details[id] != null) {
        _details[id] = _details[id]!.applyNotificationPatch(payload.orderPatch);
      }
    }
    final requestId = payload.integer('requestId');
    if (payload.kind == NotificationKind.serviceRequest && requestId != null) {
      serviceRequests[requestId] = {
        ...?serviceRequests[requestId],
        ...payload.data
      };
    }
    _controller.add(payload);
  }

  void reset() {
    _session++;
    _details.clear();
    _detailRequests.clear();
    _pendingDetailPatches.clear();
    orders.clear();
    orderEvents.clear();
    orderVersions.clear();
    revision = 0;
    serviceRequests.clear();
  }
}
