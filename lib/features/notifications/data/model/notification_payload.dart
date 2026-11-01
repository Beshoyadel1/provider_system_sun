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

  static Map<String, dynamic> object(dynamic raw) {
    if (raw is String) {
      try {
        raw = jsonDecode(raw);
      } catch (_) {
        return {};
      }
    }
    return raw is Map ? Map<String, dynamic>.from(raw) : {};
  }

  /// The existing API/SignalR models accept data -> data envelopes, including
  /// JSON strings. Use the same interpretation for foreground and worker FCM.
  static Map<String, dynamic> unwrap(Map<String, dynamic> raw) {
    final result = <String, dynamic>{};
    var current = raw;
    for (var depth = 0; depth < 8; depth++) {
      for (final entry in current.entries) {
        result[entry.key.toLowerCase().replaceAll('_', '')] = entry.value;
      }
      final nested = object(value(current, 'data'));
      if (nested.isEmpty || identical(nested, current)) break;
      current = nested;
    }
    result['fromuser'] ??= result['fromuserid'];
    result['touser'] ??= result['touserid'];
    return result;
  }

  dynamic get(String key) => value(data, key);
  int? integer(String key) => int.tryParse('${get(key)}');
  String get type {
    final primary = get('type')?.toString().trim();
    return (primary?.isNotEmpty == true
            ? primary!
            : '${get('eventType') ?? ''}')
        .toLowerCase()
        .replaceAll('_', '');
  }

  NotificationKind get kind {
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

  bool get isOrder => const {
        NotificationKind.newOrder,
        NotificationKind.orderStatus,
        NotificationKind.orderAssigned,
        NotificationKind.deliveryStatus,
        NotificationKind.offerAccepted,
      }.contains(kind);

  Map<String, dynamic> get orderPatch {
    final raw = object(get('orderInfo'));
    final patch = {for (final e in raw.entries) e.key.toLowerCase(): e.value};
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
    final id = integer('orderId') ??
        int.tryParse('${patch['id']}') ??
        int.tryParse('${value(delivery, 'orderId')}');
    if (id != null) patch['id'] = id;
    final status = (detailsRefreshed
            ? int.tryParse('${patch['orderstatus'] ?? patch['status']}')
            : integer('status') ??
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
    return patch;
  }

  int? get orderId => int.tryParse('${orderPatch['id']}');
  bool get detailsRefreshed => boolean(get('detailsRefreshed')) == true;
  Map<String, dynamic> get notification => object(get('notification'));
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

  /// Recipient fields are separate from the order creator's USERID/USERTYPE.
  bool isFor(int userId, int userType) {
    if (kind == NotificationKind.deliveryStatus) {
      if (userType != UserType.providerUser) return false;
      final delivery = object(get('deliveryOrder'));
      final providerId = integer('provid') ??
          integer('providerId') ??
          int.tryParse('${value(delivery, 'provid')}');
      if (providerId != null && providerId > 0 && providerId != userId)
        return false;
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
    final recipientId = integer('toUserId') ??
        integer('toUser') ??
        (kind == NotificationKind.chat ? null : integer('userId'));
    final recipientType = integer('toUserType') ??
        (kind == NotificationKind.chat ? null : integer('userType'));
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
