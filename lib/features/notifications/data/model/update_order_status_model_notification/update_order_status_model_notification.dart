import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/auth_local_storage.dart';
import '../../../../../../features/notifications/data/model/new_order_notifications_model/new_order_notifications_model.dart';
import 'package:flutter/foundation.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

class UpdateOrderStatusModelNotification {
  final int? userId;
  final int? userType;
  final UpdateOrderStatusNotificationData? data;

  UpdateOrderStatusModelNotification({
    this.userId,
    this.userType,
    this.data,
  });

  factory UpdateOrderStatusModelNotification.fromJson(
      Map<String, dynamic> json,
      ) {
    Map<String, dynamic> bodyData = {};
    if (json["data"] is Map) {
      bodyData = Map<String, dynamic>.from(json["data"]);
    } else if (json["data"] is String) {
      try {
        bodyData = Map<String, dynamic>.from(jsonDecode(json["data"]));
      } catch (_) {}
    }

    final Map<String, dynamic> innerData = (bodyData["data"] is Map)
        ? Map<String, dynamic>.from(bodyData["data"])
        : (bodyData.isNotEmpty ? bodyData : json);

    final toUserId = _parseInt(json["toUserId"] ?? json["TOUSERID"] ?? innerData["toUserId"] ?? innerData["TOUSERID"]);
    final toUserType = _parseInt(json["toUserType"] ?? json["TOUSERTYPE"] ?? innerData["toUserType"] ?? innerData["TOUSERTYPE"]);

    return UpdateOrderStatusModelNotification(
      userId: toUserId ?? _parseInt(json["userId"] ?? json["USERID"] ?? innerData["userId"]),
      userType: toUserType ?? _parseInt(json["userType"] ?? json["USERTYPE"] ?? innerData["userType"]),
      data: UpdateOrderStatusNotificationData(
        title: (bodyData["title"] ?? json["title"] ?? "").toString(),
        body: (bodyData["body"] ?? json["body"] ?? "").toString(),
        data: UpdateOrderStatusData.fromJson(innerData),
      ),
    );
  }

  Future<bool> canView() async {
    final currentUser = await AuthLocalStorage.getUser();

    if (currentUser == null) {
      return false;
    }

    if (userType != null &&
        userType != 0 &&
        userType != currentUser.type) {
      debugPrint("❌ UserType Not Match");
      return false;
    }

    if (userId != null &&
        userId != 0 &&
        userId != currentUser.userid) {
      debugPrint("❌ UserId Not Match");
      return false;
    }

    debugPrint("✅ UpdateOrderStatus Accepted");
    return true;
  }
}

class UpdateOrderStatusNotificationData {
  final String? title;
  final String? body;
  final UpdateOrderStatusData? data;

  UpdateOrderStatusNotificationData({
    this.title,
    this.body,
    this.data,
  });

  factory UpdateOrderStatusNotificationData.fromJson(
      Map<String, dynamic> json,
      ) {
    return UpdateOrderStatusNotificationData(
      title: json["title"]?.toString(),
      body: json["body"]?.toString(),
      data: json["data"] == null
          ? null
          : UpdateOrderStatusData.fromJson(
              Map<String, dynamic>.from(json["data"] as Map),
            ),
    );
  }
}

class UpdateOrderStatusData {
  final String? type;
  final String? orderId;
  final String? status;
  final OrderInfo? orderInfo;

  UpdateOrderStatusData({
    this.type,
    this.orderId,
    this.status,
    this.orderInfo,
  });

  factory UpdateOrderStatusData.fromJson(
      Map<String, dynamic> json,
      ) {
    dynamic orderInfoRaw = json["orderInfo"] ?? json["orderinfo"] ?? json["ORDERINFO"];
    Map<String, dynamic>? orderInfoMap;
    if (orderInfoRaw is Map) {
      orderInfoMap = Map<String, dynamic>.from(orderInfoRaw);
    } else if (orderInfoRaw is String && orderInfoRaw.isNotEmpty) {
      try {
        orderInfoMap = Map<String, dynamic>.from(jsonDecode(orderInfoRaw));
      } catch (_) {}
    }

    return UpdateOrderStatusData(
      type: json["type"]?.toString(),
      orderId: (json["orderId"] ?? json["orderid"] ?? json["ORDERID"] ?? orderInfoMap?["ID"])?.toString(),
      status: (json["status"] ?? json["orderstatus"] ?? json["ORDERSTATUS"] ?? orderInfoMap?["ORDERSTATUS"])?.toString(),
      orderInfo: orderInfoMap != null ? OrderInfo.fromJson(orderInfoMap) : null,
    );
  }
}