import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/api/api_json.dart';
import '../notification_payload.dart';

class GetUserNotificationResponse {
  final List<NotificationModel> data;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetUserNotificationResponse({
    required this.data,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetUserNotificationResponse.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    _checkNotificationSuccess(json);
    final raw = json.containsKey('data') ? json['data'] : json;
    final body = raw is Map ? ApiJson.object(raw) : json;
    final legacyRecords = body['data'];
    final records = switch (raw) {
      List list => list,
      _ when legacyRecords is List => legacyRecords,
      _ => body['items'],
    };
    final items = _notificationItems(records);
    final total = _notificationInt(body['totalCount']) ?? items.length;
    final size = _notificationInt(body['pageSize']);
    final pages = _notificationInt(body['pageCount']) ??
        _notificationInt(body['totalPages']) ??
        (size != null && size > 0
            ? (total / size).ceil()
            : items.isEmpty
                ? 0
                : 1);
    return GetUserNotificationResponse(
      data: items,
      pageCount: pages,
      totalCount: total,
      currentPage: _notificationInt(body['currentPage']) ??
          _notificationInt(body['pageNumber']) ??
          1,
    );
  }
}

/// A singleton response describes the latest notification, not the total unread
/// set. The loader completes it from paginated history before updating the badge.
class GetUserNewNotificationResponse {
  const GetUserNewNotificationResponse(this.data, {required this.isComplete});

  final List<NotificationModel> data;
  final bool isComplete;

  factory GetUserNewNotificationResponse.fromJson(dynamic raw) {
    if (raw is List) {
      return GetUserNewNotificationResponse(_notificationItems(raw),
          isComplete: true);
    }
    if (raw == null) {
      return const GetUserNewNotificationResponse([], isComplete: true);
    }
    if (raw is! Map) {
      throw const FormatException('Invalid unread notifications response');
    }
    final root = ApiJson.object(raw);
    _checkNotificationSuccess(root);
    final data = root.containsKey('data') ? root['data'] : root;
    if (data == null) {
      return const GetUserNewNotificationResponse([], isComplete: true);
    }
    if (data is List) {
      final page = GetUserNotificationResponse.fromJson(root);
      return GetUserNewNotificationResponse(page.data,
          isComplete: page.currentPage == 1 && page.pageCount <= 1);
    }
    if (data is Map) {
      final body = ApiJson.object(data);
      if (body.containsKey('items') || body['data'] is List) {
        final page = GetUserNotificationResponse.fromJson({'data': body});
        return GetUserNewNotificationResponse(page.data,
            isComplete: page.currentPage == 1 && page.pageCount <= 1);
      }
      return GetUserNewNotificationResponse(_notificationItems([body]),
          isComplete: false);
    }
    throw const FormatException('Invalid unread notifications response');
  }
}

int? _notificationInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value');

void _checkNotificationSuccess(Map<String, dynamic> body) {
  if (body['success'] == false || body['status'] == false) {
    throw FormatException(
        body['message']?.toString() ?? 'Failed to load notifications');
  }
}

List<NotificationModel> _notificationItems(dynamic raw) {
  if (raw is! List) {
    throw const FormatException('Invalid notifications list');
  }
  return raw.map((item) {
    if (item is! Map) {
      throw const FormatException('Invalid notification record');
    }
    final notification = NotificationModel.fromJson(ApiJson.object(item));
    if ((notification.id ?? 0) <= 0) {
      throw const FormatException('Notification ID is missing');
    }
    return notification;
  }).toList();
}

class NotificationModel {
  final NotificationPayload? payload;
  final String? localKey;
  final int? id;
  final String? title;
  final String? latinTitle;
  final String? description;
  final String? latinDesc;
  final int? toUserId;
  final int? toUserType;
  final int? fromUserId;
  final int? fromUserType;
  final bool? isViewed;
  final DateTime? date;

  NotificationModel({
    this.payload,
    this.localKey,
    this.id,
    this.title,
    this.latinTitle,
    this.description,
    this.latinDesc,
    this.toUserId,
    this.toUserType,
    this.fromUserId,
    this.fromUserType,
    this.isViewed,
    this.date,
  });

  String get key => id != null ? 'notification:$id' : localKey!;

  factory NotificationModel.fromPush(NotificationPayload payload) {
    final nested = payload.notification;
    return NotificationModel.fromJson({
      'title': payload.title,
      'description': payload.body,
      'isviewed': false,
      'date': payload.sentAt.toIso8601String(),
      ...nested,
      if (payload.notificationId != null) 'id': payload.notificationId,
    }).copyWith(localKey: payload.key, payload: payload);
  }

  NotificationModel copyWith(
          {bool? isViewed, String? localKey, NotificationPayload? payload}) =>
      NotificationModel(
        payload: payload ?? this.payload,
        id: id,
        localKey: localKey ?? this.localKey,
        title: title,
        latinTitle: latinTitle,
        description: description,
        latinDesc: latinDesc,
        toUserId: toUserId,
        toUserType: toUserType,
        fromUserId: fromUserId,
        fromUserType: fromUserType,
        isViewed: isViewed ?? this.isViewed,
        date: date,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final map = <String, dynamic>{};
    json.forEach((k, v) => map[k.toString().toLowerCase()] = v);

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    bool? parseBool(dynamic v) {
      return NotificationPayload.boolean(v);
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      final str = v.toString().trim();
      if (str.isEmpty) return null;

      final iso = DateTime.tryParse(str);
      if (iso != null) return iso;

      try {
        return DateFormat('MM/dd/yyyy HH:mm:ss').parse(str);
      } catch (_) {
        try {
          return DateFormat('yyyy-MM-dd HH:mm:ss').parse(str);
        } catch (_) {
          return null;
        }
      }
    }

    return NotificationModel(
      payload: map['type'] != null || map['eventtype'] != null
          ? NotificationPayload(json)
          : null,
      id: parseInt(map["id"]),
      title: map["title"]?.toString(),
      latinTitle: map["latintitle"]?.toString(),
      description: map["description"]?.toString(),
      latinDesc: map["latindesc"]?.toString(),
      toUserId: parseInt(map["touserid"]),
      toUserType: parseInt(map["tousertype"]),
      fromUserId: parseInt(map["fromuserid"]),
      fromUserType: parseInt(map["fromusertype"]),
      isViewed: parseBool(map["isviewed"]),
      date: parseDate(map["date"]),
    );
  }

  bool _isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String getTitle(BuildContext context) {
    return _isEnglish(context)
        ? (latinTitle?.isNotEmpty == true ? latinTitle! : (title ?? ""))
        : (title?.isNotEmpty == true ? title! : (latinTitle ?? ""));
  }

  String getDescription(BuildContext context) {
    return _isEnglish(context)
        ? (latinDesc?.isNotEmpty == true ? latinDesc! : (description ?? ""))
        : (description?.isNotEmpty == true ? description! : (latinDesc ?? ""));
  }

  String getFormattedDate(BuildContext context) {
    if (date == null) return "";

    try {
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat(
        "dd MMM yyyy • hh:mm a",
        locale,
      ).format(date!);
    } catch (_) {
      return date.toString();
    }
  }

  bool get isOrderRelated {
    final text =
        "${title ?? ''} ${latinTitle ?? ''} ${description ?? ''} ${latinDesc ?? ''}"
            .toLowerCase();
    return text.contains("order") ||
        text.contains("طلب") ||
        text.contains("خدمة") ||
        text.contains("service") ||
        text.contains("حالة");
  }

  bool get isChatRelated {
    final text =
        "${title ?? ''} ${latinTitle ?? ''} ${description ?? ''} ${latinDesc ?? ''}"
            .toLowerCase();
    return text.contains("chat") ||
        text.contains("message") ||
        text.contains("محادثة") ||
        text.contains("رسالة") ||
        text.contains("شات");
  }
}
