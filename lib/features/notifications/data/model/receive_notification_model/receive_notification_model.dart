import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class ReceiveNotificationModel {
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

  ReceiveNotificationModel({
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

  factory ReceiveNotificationModel.fromJson(Map<String, dynamic> json) {
    final map = <String, dynamic>{};
    json.forEach((key, value) {
      map[key.toString().toLowerCase()] = value;
    });

    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      final str = value.toString().toLowerCase().trim();
      return str == 'true' || str == '1';
    }

    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }

    final id = parseInt(map["id"] ?? map["notificationid"]);
    final title = (map["title"] ?? map["latintitle"] ?? map["ar_title"] ?? "").toString();
    final latinTitle = (map["latintitle"] ?? map["title"] ?? map["en_title"] ?? "").toString();
    final description = (map["description"] ?? map["body"] ?? map["message"] ?? map["latindesc"] ?? "").toString();
    final latinDesc = (map["latindesc"] ?? map["body"] ?? map["message"] ?? map["description"] ?? "").toString();
    final toUserId = parseInt(map["touserid"] ?? map["userid"]);
    final toUserType = parseInt(map["tousertype"] ?? map["usertype"]);
    final fromUserId = parseInt(map["fromuserid"]);
    final fromUserType = parseInt(map["fromusertype"]);
    final isViewed = parseBool(map["isviewed"]);
    final date = parseDate(map["date"] ?? map["timestamp"] ?? map["createdat"]);

    return ReceiveNotificationModel(
      id: id,
      title: title,
      latinTitle: latinTitle,
      description: description,
      latinDesc: latinDesc,
      toUserId: toUserId,
      toUserType: toUserType,
      fromUserId: fromUserId,
      fromUserType: fromUserType,
      isViewed: isViewed,
      date: date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "TITLE": title,
      "LATINTITLE": latinTitle,
      "DESCRIPTION": description,
      "LATINDESC": latinDesc,
      "TOUSERID": toUserId,
      "TOUSERTYPE": toUserType,
      "FROMUSERID": fromUserId,
      "FROMUSERTYPE": fromUserType,
      "ISVIEWED": isViewed,
      "DATE": date?.toIso8601String(),
    };
  }

  bool _isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String getTitle(BuildContext context) {
    return _isEnglish(context) ? (latinTitle ?? "") : (title ?? "");
  }

  String getDescription(BuildContext context) {
    return _isEnglish(context) ? (latinDesc ?? "") : (description ?? "");
  }

  String getFormattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat(
      "dd MMM yyyy • hh:mm a",
      locale,
    ).format(date!);
  }
}
