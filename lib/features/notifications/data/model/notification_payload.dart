import 'dart:convert';

enum NotificationKind {
  newOrder,
  orderStatus,
  orderAssigned,
  offerAccepted,
  serviceRequest,
  serviceOffer,
  chat,
  chatStatus,
  ownership,
  general,
}

/// The FCM data dictionary contains strings, including JSON-encoded objects.
class NotificationPayload {
  NotificationPayload(
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

  dynamic get(String key) => value(data, key);
  int? integer(String key) => int.tryParse('${get(key)}');
  String get type => '${get('type') ?? ''}'.toLowerCase().replaceAll('_', '');

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
        NotificationKind.offerAccepted,
      }.contains(kind);

  Map<String, dynamic> get orderPatch {
    final raw = object(get('orderInfo'));
    final patch = {for (final e in raw.entries) e.key.toLowerCase(): e.value};
    final id = integer('orderId') ?? int.tryParse('${patch['id']}');
    if (id != null) patch['id'] = id;
    final status = integer('status') ??
        int.tryParse('${patch['orderstatus'] ?? patch['status']}');
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
  Map<String, dynamic> get notification => object(get('notification'));
  int? get notificationId =>
      integer('notificationId') ?? int.tryParse('${value(notification, 'id')}');

  /// Recipient fields are separate from the order creator's USERID/USERTYPE.
  bool isFor(int userId, int userType) {
    final recipientId = integer('toUserId') ??
        integer('toUser') ??
        (kind == NotificationKind.chat || kind == NotificationKind.chatStatus
            ? null
            : integer('userId'));
    final recipientType = integer('toUserType') ??
        (kind == NotificationKind.chat || kind == NotificationKind.chatStatus
            ? null
            : integer('userType'));
    return (recipientId == null || recipientId == 0 || recipientId == userId) &&
        (recipientType == null ||
            recipientType == 0 ||
            recipientType == userType);
  }

  String get key {
    if (messageId?.isNotEmpty == true) return 'push:$messageId';
    if (kind == NotificationKind.chat && integer('id') != null) {
      return 'chat:${integer('id')}';
    }
    final sorted = {for (final k in (data.keys.toList()..sort())) k: data[k]};
    return '${kind.name}:${jsonEncode(sorted)}';
  }
}
