import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
    final map = <String, dynamic>{};
    json.forEach((k, v) => map[k.toString().toLowerCase()] = v);

    final rawData = map["data"];
    Map<String, dynamic> body = {};
    if (rawData is Map) {
      rawData.forEach((k, v) => body[k.toString().toLowerCase()] = v);
    } else if (rawData is List) {
      return GetUserNotificationResponse(
        data: rawData
            .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        pageCount: 1,
        totalCount: rawData.length,
        currentPage: 1,
      );
    }

    final list = (body["data"] as List?) ?? (rawData as List?) ?? [];

    int parseInt(dynamic v, int fallback) {
      if (v == null) return fallback;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? fallback;
    }

    return GetUserNotificationResponse(
      data: list
          .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      pageCount: parseInt(body["pagecount"], 0),
      totalCount: parseInt(body["totalcount"], 0),
      currentPage: parseInt(body["currentpage"], 1),
    );
  }
}

class NotificationModel {
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
    }).copyWith(localKey: payload.key);
  }

  NotificationModel copyWith({bool? isViewed, String? localKey}) =>
      NotificationModel(
        id: id, localKey: localKey ?? this.localKey,
        title: title, latinTitle: latinTitle, description: description,
        latinDesc: latinDesc, toUserId: toUserId, toUserType: toUserType,
        fromUserId: fromUserId, fromUserType: fromUserType,
        isViewed: isViewed ?? this.isViewed, date: date,
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
      if (v == null) return null;
      if (v is bool) return v;
      final str = v.toString().toLowerCase().trim();
      return str == 'true' || str == '1';
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
    final text = "${title ?? ''} ${latinTitle ?? ''} ${description ?? ''} ${latinDesc ?? ''}".toLowerCase();
    return text.contains("order") ||
        text.contains("طلب") ||
        text.contains("خدمة") ||
        text.contains("service") ||
        text.contains("حالة");
  }

  bool get isChatRelated {
    final text = "${title ?? ''} ${latinTitle ?? ''} ${description ?? ''} ${latinDesc ?? ''}".toLowerCase();
    return text.contains("chat") ||
        text.contains("message") ||
        text.contains("محادثة") ||
        text.contains("رسالة") ||
        text.contains("شات");
  }
}
