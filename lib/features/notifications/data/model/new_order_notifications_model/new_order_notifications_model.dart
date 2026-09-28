import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/auth_local_storage.dart';

class NewOrderNotificationsModel {
  final int? userId;
  final int? userType;
  final String? title;
  final String? body;
  final NewOrderData? data;

  NewOrderNotificationsModel({
    this.userId,
    this.userType,
    this.title,
    this.body,
    this.data,
  });

  factory NewOrderNotificationsModel.fromJson(
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

    return NewOrderNotificationsModel(
      userId: _parseInt(json["userId"] ?? json["USERID"] ?? innerData["userId"]),
      userType: _parseInt(json["userType"] ?? json["USERTYPE"] ?? innerData["userType"]),
      title: (bodyData["title"] ?? json["title"] ?? "").toString(),
      body: (bodyData["body"] ?? json["body"] ?? "").toString(),
      data: NewOrderData.fromJson(innerData),
    );
  }
}

class NewOrderData {
  final String? type;
  final int? orderId;
  final OrderInfo? orderInfo;

  NewOrderData({
    this.type,
    this.orderId,
    this.orderInfo,
  });

  factory NewOrderData.fromJson(
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

    return NewOrderData(
      type: json["type"]?.toString() ?? "",
      orderId: _parseInt(json["orderId"] ?? json["orderid"] ?? json["ORDERID"] ?? orderInfoMap?["ID"]),
      orderInfo: orderInfoMap != null ? OrderInfo.fromJson(orderInfoMap) : null,
    );
  }
}

class OrderInfo {
  final int? id;
  final int? userId;
  final int? userType;
  final int? orderStatus;
  final String? userName;
  final DateTime? orderDate;
  final double? totalPrice;

  OrderInfo({
    this.id,
    this.userId,
    this.userType,
    this.orderStatus,
    this.userName,
    this.orderDate,
    this.totalPrice,
  });

  factory OrderInfo.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderInfo(
      id: _parseInt(json["ID"] ?? json["id"]),
      userId: _parseInt(json["USERID"] ?? json["userId"] ?? json["userid"]),
      userType: _parseInt(json["USERTYPE"] ?? json["userType"] ?? json["usertype"]),
      orderStatus: _parseInt(json["ORDERSTATUS"] ?? json["orderStatus"] ?? json["orderstatus"]),
      userName: (json["USERNAME"] ?? json["userName"] ?? json["username"])?.toString() ?? "",
      orderDate: DateTime.tryParse(
        (json["ORDERDATE"] ?? json["orderDate"] ?? json["orderdate"])?.toString() ?? "",
      ),
      totalPrice: double.tryParse((json["TOTALPRICE"] ?? json["totalPrice"] ?? json["totalprice"])?.toString() ?? "0") ?? 0,
    );
  }

  Future<bool> canView() async {
    final currentUser = await AuthLocalStorage.getUser();

    if (currentUser == null) {
      return false;
    }

    debugPrint("✅ Order Accepted for provider ${currentUser.userid}");
    return true;
  }
}

int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  return 0;
}