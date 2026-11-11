import 'dart:async';
import '../../../core/api/api_json.dart';
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
  final Set<int> _staleDetails = {};
  final Map<int, Future<OrderDetailsModel>> _detailRequests = {};
  final Set<int> _enrichingOrders = {};
  final Map<int, Map<String, dynamic>> _pendingDetailPatches = {};
  final Map<Object, bool Function(NotificationPayload)> _orderConsumers = {};
  int _session = 0;
  Stream<NotificationPayload> get stream => _controller.stream;

  Map<String, dynamic> _mergeOrderPatch(
          Map<String, dynamic> previous, Map<String, dynamic> incoming) =>
      {
        ...previous,
        ...incoming,
        if (previous['deliveryorder'] is Map &&
            incoming['deliveryorder'] is Map)
          'deliveryorder': ApiJson.object({
            ...previous['deliveryorder'] as Map,
            ...incoming['deliveryorder'] as Map,
          }),
      };

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
    if (!force && !_staleDetails.contains(id) && _details[id] != null) {
      return _details[id]!;
    }
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
        _staleDetails.remove(id);
        // Fresh API fields supersede older patches.
        orders[id] = {
          ...after,
          if (result.status != null) ...{
            'status': result.status,
            'orderstatus': result.status,
          },
          if (result.statusHistory != null)
            'statushistory':
                result.statusHistory!.map((event) => event.toJson()).toList(),
          if (result.deliveryOrder != null)
            'deliveryorder': result.deliveryOrder!.toJson(),
          if (result.isDeliveryOrder != null)
            'isdeliveryorder': result.isDeliveryOrder,
          if (result.isOnSite != null) 'isonsite': result.isOnSite,
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
    if (id == null ||
        id <= 0 ||
        payload.detailsRefreshed ||
        !needsOrderDetails(payload) ||
        !_enrichingOrders.add(id)) {
      return;
    }
    final session = _session;
    try {
      final details = await getOrderDetails(id);
      if (session != _session) return;
      final latest = orderEvents[id] ?? payload;
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
        'provname': details.providerInfo?.name,
        'provlatinname': details.providerInfo?.latinname,
        'branchname': details.providerInfo?.branchname,
        'branchlatinname': details.providerInfo?.branchlatinname,
        if (details.deliveryOrder != null)
          'deliveryorder': details.deliveryOrder!.toJson(),
        'isdeliveryorder': details.isDeliveryOrder,
        'isonsite': details.isOnSite,
        'statusHistory':
            details.statusHistory?.map((event) => event.toJson()).toList(),
        ...?orders[id],
        if (details.services?.isNotEmpty == true)
          'services':
              details.services!.map((service) => service.toJson()).toList(),
        if (details.provid != null && details.provid! > 0)
          'provid': details.provid,
      }..removeWhere((_, value) => value == null);
      add(NotificationPayload({
        ...latest.data,
        'detailsRefreshed': true,
        'orderInfo': patch,
      },
          title: latest.title,
          body: latest.body,
          messageId: latest.messageId,
          sentAt: latest.sentAt));
    } finally {
      if (session == _session) _enrichingOrders.remove(id);
    }
  }

  void add(NotificationPayload payload) {
    final id = payload.isOrder ? payload.orderId : null;
    if (id != null && id > 0) {
      orderEvents[id] = payload;
      orderVersions[id] = ++revision;
      orders[id] = _mergeOrderPatch(orders[id] ?? {}, payload.orderPatch);
      if (_pendingDetailPatches.containsKey(id)) {
        _pendingDetailPatches[id] =
            _mergeOrderPatch(_pendingDetailPatches[id]!, payload.orderPatch);
      }
      if (_details[id] != null) {
        _details[id] = _details[id]!.applyNotificationPatch(payload.orderPatch);
      }
      if ((payload.kind == NotificationKind.deliveryStatus ||
              payload.kind == NotificationKind.orderStatus ||
              payload.kind == NotificationKind.orderAssigned) &&
          !payload.detailsRefreshed) {
        _staleDetails.add(id);
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
    _staleDetails.clear();
    _detailRequests.clear();
    _enrichingOrders.clear();
    _pendingDetailPatches.clear();
    orders.clear();
    orderEvents.clear();
    orderVersions.clear();
    revision = 0;
    serviceRequests.clear();
  }
}
