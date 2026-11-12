import 'dart:convert';
import '../../../../core/api/dio_function/api_constants.dart';
import '../../../technical_support/data/model/chat_identity.dart';
import '../../../internal_services/data/model/get_provider_orders_model/delivery_order_model.dart';

enum NotificationKind {
  newOrder,
  orderStatus,
  deliveryStatus,
  orderAssigned,
  offerAccepted,
  serviceRequest,
  serviceOffer,
  chat,
  chatStatus,
  supportTicket,
  ownership,
  general,
}

/// The FCM data dictionary contains strings, including JSON-encoded objects.
class NotificationPayload {
  NotificationPayload(
    Map<String, dynamic> data, {
    String? title,
    String? body,
    String? messageId,
    DateTime? sentAt,
  }) : this._(unwrap(data),
            title: title, body: body, messageId: messageId, sentAt: sentAt);

  NotificationPayload._(
    Map<String, dynamic> data, {
    String? title,
    String? body,
    this.messageId,
    DateTime? sentAt,
  })  : data = Map.unmodifiable(data),
        sentAt = sentAt ?? DateTime.now(),
        title = title ??
            value(data, 'title')?.toString() ??
            value(object(value(data, 'notification')), 'title')?.toString() ??
            '',
        body = body ??
            value(data, 'body')?.toString() ??
            value(data, 'message')?.toString() ??
            value(data, 'description')?.toString() ??
            value(object(value(data, 'notification')), 'body')?.toString() ??
            value(object(value(data, 'notification')), 'description')
                ?.toString() ??
            '';

  final Map<String, dynamic> data;
  final String title;
  final String body;
  final String? messageId;
  final DateTime sentAt;

  static dynamic value(Map data, String key) {
    final normalized = key.toLowerCase().replaceAll('_', '');
    for (final entry in data.entries) {
      if (entry.key.toString().toLowerCase().replaceAll('_', '') ==
          normalized) {
        return entry.value;
      }
    }
    return null;
  }

  static dynamic _decodeJson(dynamic raw) {
    if (raw is String) {
      try {
        return jsonDecode(raw);
      } catch (_) {
        return null;
      }
    }
    return raw;
  }

  static Map<String, dynamic> object(dynamic raw) {
    final decoded = _decodeJson(raw);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
  }

  /// The existing API/SignalR models accept data -> data envelopes, including
  /// JSON strings. Use the same interpretation for foreground and worker FCM.
  static Map<String, dynamic> unwrap(Map<String, dynamic> raw) {
    final result = <String, dynamic>{};
    var current = raw;
    dynamic envelopeUserId, envelopeUserType;
    for (var depth = 0; depth < 8; depth++) {
      final nested = object(value(current, 'data'));
      for (final entry in current.entries) {
        final key = entry.key.toLowerCase().replaceAll('_', '');
        if (key != 'data' || nested.isEmpty) result[key] = entry.value;
      }
      if (nested.isEmpty) break;
      envelopeUserId ??= value(current, 'userId');
      envelopeUserType ??= value(current, 'userType');
      current = nested;
    }
    // Keep legacy envelope recipients even when inner order data has USERID.
    if (envelopeUserId != null) result['envelopeuserid'] = envelopeUserId;
    if (envelopeUserType != null) result['envelopeusertype'] = envelopeUserType;
    result['fromuser'] ??= result['fromuserid'];
    result['touser'] ??= result['touserid'];
    return result;
  }

  dynamic get(String key) => value(data, key);
  int? integer(String key) => int.tryParse('${get(key)}');
  static String _eventName(dynamic raw) =>
      '${raw ?? ''}'.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');

  late final String type = _readType();
  String _readType() {
    final candidates = [
      get('type'),
      get('eventType'),
      value(notification, 'type'),
      value(notification, 'eventType'),
    ].map(_eventName);
    return candidates.firstWhere(
      (event) => _kindFor(event) != NotificationKind.general,
      orElse: () =>
          candidates.firstWhere((event) => event.isNotEmpty, orElse: () => ''),
    );
  }

  static NotificationKind _kindFor(String type) {
    switch (type) {
      case 'neworder':
        return NotificationKind.newOrder;
      case 'updateorderstatus':
      case 'orderstatus':
      case 'ordercancelled':
      case 'cancelorder':
        return NotificationKind.orderStatus;
      case 'orderassigned':
        return NotificationKind.orderAssigned;
      case 'deliverystatusupdated':
        return NotificationKind.deliveryStatus;
      case 'acceptserviceoffer':
      case 'offeraccepted':
        return NotificationKind.offerAccepted;
      case 'newservicerequest':
        return NotificationKind.serviceRequest;
      case 'newserviceoffer':
        return NotificationKind.serviceOffer;
      case 'chat':
      case 'receivemessage':
        return NotificationKind.chat;
      case 'openclosechat':
        return NotificationKind.chatStatus;
      case 'supportticket':
        return NotificationKind.supportTicket;
      case 'transferownership':
        return NotificationKind.ownership;
      default:
        return NotificationKind.general;
    }
  }

  late final NotificationKind kind = _readKind();
  NotificationKind _readKind() {
    final explicit = _kindFor(type);
    if (explicit != NotificationKind.general) return explicit;
    final order = object(get('orderInfo'));
    final orderId = integer('orderId');
    final id = ((orderId ?? 0) > 0 ? orderId : null) ??
        int.tryParse('${value(order, 'id') ?? value(order, 'orderId')}');
    final status = integer('orderStatus') ??
        integer('status') ??
        int.tryParse(
            '${value(order, 'orderStatus') ?? value(order, 'status')}');
    // Some legacy pushes carry an order record without an event name.
    if ((id ?? 0) <= 0 || (order.isEmpty && integer('orderStatus') == null)) {
      return explicit;
    }
    return status == null || OrderType.newOrders.contains(status)
        ? NotificationKind.newOrder
        : NotificationKind.orderStatus;
  }

  bool get isOrder => const {
        NotificationKind.newOrder,
        NotificationKind.orderStatus,
        NotificationKind.orderAssigned,
        NotificationKind.deliveryStatus,
        NotificationKind.offerAccepted,
      }.contains(kind);

  late final Map<String, dynamic> orderPatch =
      Map.unmodifiable(_readOrderPatch());
  Map<String, dynamic> _readOrderPatch() {
    final raw = object(get('orderInfo'));
    final patch = {
      for (final e in raw.entries)
        e.key.toLowerCase().replaceAll('_', ''): e.value,
    };
    for (final field in const [
      'branchId',
      'branchName',
      'branchLatinName',
      'serviceId',
      'services',
      'username',
      'orderDate',
      'totalPrice',
      'provid',
      'isDeliveryOrder',
      'provServices',
      'servicePackages',
      'car',
    ]) {
      final key = field.toLowerCase();
      patch[key] ??= get(field);
    }
    patch['provid'] ??= get('providerId') ?? value(raw, 'providerId');
    if (_hasFlatOrderCreator) {
      patch['userid'] ??= get('userId');
      patch['usertype'] ??= get('userType');
    }
    for (final field in const ['services', 'provservices', 'servicepackages']) {
      final list = _decodeJson(patch[field]);
      if (list is List) patch[field] = list;
    }
    if (patch['services'] case final List services) {
      patch['services'] = [
        for (final service in services.whereType<Map>())
          {
            for (final e in service.entries)
              e.key.toString().toLowerCase().replaceAll('_', ''): e.value,
          },
      ];
    }
    final isDelivery = boolean(patch['isdeliveryorder']);
    if (isDelivery != null) patch['isdeliveryorder'] = isDelivery;
    final delivery =
        object(get('deliveryOrder') ?? value(raw, 'deliveryOrder'));
    if (kind == NotificationKind.deliveryStatus && !detailsRefreshed) {
      for (final entry in {
        'deliveryOrderStatus': get('deliveryOrderStatus') ??
            get('deliveryStatus') ??
            get('orderStatus'),
        'mandoobName': get('mandoobName') ?? get('courierName'),
        'mandoobPhone': get('mandoobPhone') ?? get('courierPhone'),
        'deliveryFee': get('deliveryFee'),
        'deliveryOrderId': get('deliveryOrderId'),
        'mandoobAcceptOrderDate': get('mandoobAcceptOrderDate'),
        'mandoobReceiveOrderDate': get('mandoobReceiveOrderDate'),
        'mandoobDeliverOrderDate': get('mandoobDeliverOrderDate'),
      }.entries) {
        if (entry.value != null) delivery[entry.key] = entry.value;
      }
      patch['isdeliveryorder'] = true;
    }
    if (delivery.isNotEmpty) patch['deliveryorder'] = delivery;
    final explicitId = integer('orderId');
    final id = ((explicitId ?? 0) > 0 ? explicitId : null) ??
        int.tryParse('${patch['id'] ?? patch['orderid']}') ??
        int.tryParse('${value(delivery, 'orderId')}');
    if (id != null) patch['id'] = id;
    final status = (detailsRefreshed
            ? int.tryParse('${patch['orderstatus'] ?? patch['status']}')
            : integer('orderStatus') ??
                integer('status') ??
                int.tryParse('${patch['orderstatus'] ?? patch['status']}')) ??
        ((type == 'ordercancelled' || type == 'cancelorder')
            ? OrderStatus.cancelledByUser
            : null) ??
        (kind == NotificationKind.deliveryStatus
            ? switch (DeliveryOrderModel.normalizeStatus(
                value(delivery, 'deliveryOrderStatus'))) {
                'picked' => OrderStatus.employeeInRoad,
                'delivered' => OrderStatus.orderCompleted,
                'cancelled' => OrderStatus.cancelledByUser,
                _ => null,
              }
            : null);
    if (status != null) {
      patch['orderstatus'] = status;
      patch['status'] = status;
    }
    if (!patch.containsKey('orderdate') && patch['date'] != null) {
      patch['orderdate'] = patch['date'];
    }
    return patch..removeWhere((_, value) => value == null);
  }

  int? get orderId => int.tryParse('${orderPatch['id']}');
  bool get detailsRefreshed => boolean(get('detailsRefreshed')) == true;
  late final Map<String, dynamic> notification = object(get('notification'));
  int? get notificationId =>
      integer('notificationId') ?? int.tryParse('${value(notification, 'id')}');

  ChatIdentity? chatPeer(int userId, int userType) => ChatIdentity.peer(
        userId: userId,
        userType: userType,
        fromId: integer('fromuser'),
        fromType: integer('fromusertype'),
        toId: integer('touser'),
        toType: integer('tousertype'),
      );

  int? contextId(String field) {
    final raw = get(field)?.toString().trim();
    if (raw == null || raw.isEmpty || raw.toLowerCase() == 'null') return 0;
    return int.tryParse(raw);
  }

  bool get isDirectChat =>
      ['orderId', 'harageId'].every((field) => contextId(field) == 0);

  static bool? boolean(dynamic raw) {
    switch ('$raw'.trim().toLowerCase()) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
      default:
        return null;
    }
  }

  bool get _hasFlatOrderCreator {
    final type = integer('userType');
    if (type != null &&
        type != UserType.appUser &&
        type != UserType.companyUser) {
      return false;
    }
    return get('username') != null ||
        (type != null &&
            (integer('envelopeUserId') != null ||
                integer('provid') != null ||
                integer('providerId') != null));
  }

  /// Recipient fields are separate from the order creator's USERID/USERTYPE.
  bool isFor(int userId, int userType) {
    if (kind == NotificationKind.deliveryStatus) {
      if (userType != UserType.providerUser) return false;
      final delivery = object(get('deliveryOrder'));
      final providerId = integer('provid') ??
          integer('providerId') ??
          int.tryParse('${value(delivery, 'provid')}');
      if (providerId != null && providerId > 0 && providerId != userId) {
        return false;
      }
    }
    // Harag already has a group-chat consumer that validates the ad and its
    // contributors. Its broadcast messages can omit TOUSER/TOUSERTYPE.
    if (kind == NotificationKind.chatStatus ||
        (kind == NotificationKind.chat && (integer('harageId') ?? 0) <= 0)) {
      return chatPeer(userId, userType) != null;
    }
    if (kind == NotificationKind.supportTicket &&
        userType != UserType.adminUser) {
      return false;
    }
    if (kind == NotificationKind.offerAccepted &&
        userType != UserType.providerUser) {
      return false;
    }
    final hasOrder = isOrder;
    if (hasOrder && userType == UserType.providerUser) {
      final providerId = int.tryParse('${orderPatch['provid']}');
      if (providerId != null && providerId > 0 && providerId != userId) {
        return false;
      }
    }
    final useFlatRecipient =
        kind != NotificationKind.chat && (!hasOrder || !_hasFlatOrderCreator);
    final recipientId = integer('toUserId') ??
        integer('toUser') ??
        int.tryParse('${value(notification, 'toUserId')}') ??
        (hasOrder ? integer('envelopeUserId') : null) ??
        (useFlatRecipient ? integer('userId') : null);
    final recipientType = integer('toUserType') ??
        int.tryParse('${value(notification, 'toUserType')}') ??
        (hasOrder ? integer('envelopeUserType') : null) ??
        (useFlatRecipient ? integer('userType') : null);
    return (recipientId == null || recipientId == 0 || recipientId == userId) &&
        (recipientType == null ||
            recipientType == 0 ||
            recipientType == userType);
  }

  String get key {
    if (kind == NotificationKind.chat && (integer('id') ?? 0) > 0) {
      return 'chat:${integer('id')}';
    }
    if (messageId?.isNotEmpty == true) return 'push:$messageId';
    final sorted = {for (final k in (data.keys.toList()..sort())) k: data[k]};
    return '${kind.name}:${jsonEncode(sorted)}';
  }
}
