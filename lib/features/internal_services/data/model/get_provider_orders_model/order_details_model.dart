import 'package:sun_web_system/core/api/api_json.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sun_web_system/core/utilies/api_image.dart';
import 'delivery_order_model.dart';
import 'order_line_item.dart';
import 'order_discounts.dart';

OrderDetailsModel orderModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

bool? _orderBool(Object? value) {
  switch ('$value'.toLowerCase()) {
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

class OrderDetailsModel {
  OrderDetailsModel({
    this.date,
    this.branchid,
    this.notes,
    this.appointment,
    this.nationaladdress,
    this.userid,
    this.long,
    this.offer,
    this.employeeInfos,
    this.id,
    this.provid,
    this.lat,
    this.totalprice,
    this.rates,
    this.usertype,
    this.services,
    this.cars,
    this.statusHistory,
    this.taxamount,
    this.user,
    this.paymentmethod,
    this.providerInfo,
    this.status,
    this.deliveryOrder,
    this.isDeliveryOrder,
    this.isOnSite,
    this.coupon,
    this.points,
  });

  DateTime? date;
  int? branchid;
  String? notes;
  DateTime? appointment;
  String? nationaladdress;
  int? userid;
  double? long;
  Offer? offer;
  List<dynamic>? employeeInfos;
  int? id;
  int? provid;
  double? lat;
  num? totalprice;
  List<dynamic>? rates;
  int? usertype;
  List<Service>? services;
  List<Car>? cars;
  List<StatusHistory>? statusHistory;
  num? taxamount;
  User? user;
  int? paymentmethod;
  ProviderInfo? providerInfo;
  int? status;
  DeliveryOrderModel? deliveryOrder;
  bool? isDeliveryOrder;
  bool? isOnSite;
  OrderCoupon? coupon;
  OrderPoints? points;
  bool get hasDelivery => isDeliveryOrder ?? deliveryOrder != null;

  OrderDetailsModel applyNotificationPatch(Map<String, dynamic> patch) {
    patch = ApiJson.object(patch);
    int? number(String key, int? fallback) =>
        int.tryParse('${patch[key]}') ?? fallback;
    double? decimal(String key, double? fallback) =>
        double.tryParse('${patch[key]}') ?? fallback;
    return OrderDetailsModel(
      id: id,
      status: number('status', status),
      date: DateTime.tryParse('${patch['date']}') ?? date,
      branchid: number('branchid', branchid),
      notes: patch['notes']?.toString() ?? notes,
      appointment: DateTime.tryParse('${patch['appointment']}') ?? appointment,
      nationaladdress: patch['nationaladdress']?.toString() ?? nationaladdress,
      userid: number('userid', userid),
      usertype: number('usertype', usertype),
      provid: number('provid', provid),
      lat: decimal('lat', lat),
      long: decimal('long', long),
      totalprice: num.tryParse('${patch['totalprice']}') ?? totalprice,
      taxamount: num.tryParse('${patch['taxamount']}') ?? taxamount,
      offer: offer,
      employeeInfos: employeeInfos,
      rates: rates,
      services: services,
      cars: cars,
      user: user,
      paymentmethod: paymentmethod,
      providerInfo: providerInfo,
      coupon: patch['coupon'] is Map
          ? OrderCoupon.fromJson(
              {...?coupon?.toJson(), ...patch['coupon'] as Map})
          : coupon,
      points: patch['points'] is Map
          ? OrderPoints.fromJson(
              {...?points?.toJson(), ...patch['points'] as Map})
          : points,
      statusHistory: patch['statusHistory'] is List
          ? (patch['statusHistory'] as List)
              .whereType<Map>()
              .map(StatusHistory.fromJson)
              .toList()
          : statusHistory,
      deliveryOrder: patch['deliveryOrder'] is Map
          ? (deliveryOrder ?? DeliveryOrderModel())
              .applyPatch(patch['deliveryOrder'])
          : deliveryOrder,
      isDeliveryOrder: _orderBool(patch['isDeliveryOrder']) ?? isDeliveryOrder,
      isOnSite: _orderBool(patch['isOnSite']) ?? isOnSite,
    );
  }

  factory OrderDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return OrderDetailsModel(
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      branchid: json["branchid"],
      notes: json["notes"],
      appointment: json["appointment"] == null
          ? null
          : DateTime.parse(json["appointment"]),
      nationaladdress: json["nationaladdress"],
      userid: json["userid"],
      long: (json["long"] as num?)?.toDouble(),
      offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
      employeeInfos:
          (json["employeeInfos"] as List? ?? []).map((e) => e).toList(),
      id: json["id"],
      provid: json["provid"],
      lat: (json["lat"] as num?)?.toDouble(),
      totalprice: json["totalprice"],
      rates: (json["rates"] as List? ?? []).map((e) => e).toList(),
      usertype: json["usertype"],
      services: (json["services"] as List? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
      cars: (json["cars"] as List? ?? []).map((e) => Car.fromJson(e)).toList(),
      statusHistory: (json["statusHistory"] as List? ?? [])
          .map((e) => StatusHistory.fromJson(e))
          .toList(),
      taxamount: json["taxamount"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      paymentmethod: json["paymentmethod"],
      providerInfo: json["providerInfo"] == null
          ? null
          : ProviderInfo.fromJson(json["providerInfo"]),
      status: json["status"],
      deliveryOrder: json['deliveryOrder'] is Map
          ? DeliveryOrderModel.fromJson(json['deliveryOrder'])
          : null,
      isDeliveryOrder: _orderBool(json['isDeliveryOrder']),
      isOnSite: _orderBool(json['isOnSite']),
      coupon:
          json['coupon'] is Map ? OrderCoupon.fromJson(json['coupon']) : null,
      points:
          json['points'] is Map ? OrderPoints.fromJson(json['points']) : null,
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "branchid": branchid,
        "notes": notes,
        "appointment": appointment?.toIso8601String(),
        "nationaladdress": nationaladdress,
        "userid": userid,
        "long": long,
        "offer": offer?.toJson(),
        "employeeInfos": employeeInfos ?? [],
        "id": id,
        "provid": provid,
        "lat": lat,
        "totalprice": totalprice,
        "rates": rates ?? [],
        "usertype": usertype,
        "services": services?.map((e) => e.toJson()).toList() ?? [],
        "cars": cars?.map((e) => e.toJson()).toList() ?? [],
        "statusHistory": statusHistory?.map((e) => e.toJson()).toList() ?? [],
        "taxamount": taxamount,
        "user": user?.toJson(),
        "paymentmethod": paymentmethod,
        "providerInfo": providerInfo?.toJson(),
        "status": status,
        'deliveryOrder': deliveryOrder?.toJson(),
        'isDeliveryOrder': isDeliveryOrder,
        'isOnSite': isOnSite,
        'coupon': coupon?.toJson(),
        'points': points?.toJson(),
      };
}

class Car {
  Car({
    this.image,
    this.totalprice,
    this.products,
    this.provServices,
    this.servicePackages,
    this.id,
    this.releasedate,
    this.ownerid,
    this.ownertype,
    this.chassisno,
    this.plateno,
    this.insuranceno,
    this.licenceimage,
    this.name,
    this.brand,
    this.model,
  });

  Uint8List? image;
  num? totalprice;
  List<OrderLineItem>? products;
  List<ProvService>? provServices;
  List<OrderLineItem>? servicePackages;

  int? id;
  int? releasedate;
  int? ownerid;
  int? ownertype;

  String? chassisno;
  String? plateno;
  String? insuranceno;
  Uint8List? licenceimage;
  String? name;

  Brand? brand;
  Model? model;

  factory Car.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return Car(
      image: decodeApiImage(json["image"]),
      totalprice: json["totalprice"],
      products: (json["products"] as List? ?? [])
          .whereType<Map>()
          .map((e) => OrderLineItem.fromJson(e, OrderLineKind.product))
          .toList(),
      provServices: (json["provServices"] as List? ?? [])
          .map((e) => ProvService.fromJson(e))
          .toList(),
      servicePackages: (json["servicePackages"] as List? ?? [])
          .whereType<Map>()
          .map((e) => OrderLineItem.fromJson(e, OrderLineKind.package))
          .toList(),
      id: json["id"],
      releasedate: json["releasedate"],
      ownerid: json["ownerid"],
      ownertype: json["ownertype"],
      chassisno: json["chassisno"],
      plateno: json["plateno"],
      insuranceno: json["insuranceno"],
      licenceimage: decodeApiImage(json["licenceimage"]),
      name: json["name"],
      brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
      model: json["model"] == null ? null : Model.fromJson(json["model"]),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "totalprice": totalprice,
        "products": products?.map((e) => e.toJson()).toList() ?? [],
        "provServices": provServices?.map((e) => e.toJson()).toList() ?? [],
        "servicePackages":
            servicePackages?.map((e) => e.toJson()).toList() ?? [],
        "id": id,
        "releasedate": releasedate,
        "ownerid": ownerid,
        "ownertype": ownertype,
        "chassisno": chassisno,
        "plateno": plateno,
        "insuranceno": insuranceno,
        "licenceimage": licenceimage,
        "name": name,
        "brand": brand?.toJson(),
        "model": model?.toJson(),
      };
}

class Brand {
  Brand({
    this.carbrandid,
    this.brandname,
    this.brandlatinname,
    this.image,
  });

  int? carbrandid;
  String? brandname;
  String? brandlatinname;
  Uint8List? image;

  factory Brand.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return Brand(
      carbrandid: json["carbrandid"],
      brandname: json["brandname"],
      brandlatinname: json["brandlatinname"],
      image: decodeApiImage(json["image"]),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "carbrandid": carbrandid,
        "brandname": brandname,
        "brandlatinname": brandlatinname,
        "image": image,
      };
}

class Model {
  Model({
    this.carmodelid,
    this.modelname,
    this.image,
  });

  int? carmodelid;
  String? modelname;
  Uint8List? image;

  factory Model.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return Model(
      carmodelid: json["carmodelid"],
      modelname: json["modelname"],
      image: decodeApiImage(json["image"]),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "carmodelid": carmodelid,
        "modelname": modelname,
        "image": image,
      };
}

class ProvService {
  ProvService({
    this.quantity,
    this.cost,
    this.orderid,
    this.taxpercentage,
    this.price,
    this.totalprice,
    this.name,
    this.provserviceid,
    this.id,
    this.latinname,
    this.carid,
    this.ispetrol,
  });

  num? quantity;
  num? cost;
  int? orderid;
  num? taxpercentage;
  num? price;
  num? totalprice;
  String? name;
  int? provserviceid;
  int? id;
  String? latinname;
  int? carid;
  bool? ispetrol;

  factory ProvService.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return ProvService(
      quantity: json["quantity"],
      cost: json["cost"],
      orderid: json["orderid"],
      taxpercentage: json["taxpercentage"],
      price: json["price"],
      totalprice: json["totalprice"],
      name: json["name"],
      provserviceid: json["provserviceid"],
      id: json["id"],
      latinname: json["latinname"],
      carid: json["carid"],
      ispetrol: json["ispetrol"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "quantity": quantity,
        "cost": cost,
        "orderid": orderid,
        "taxpercentage": taxpercentage,
        "price": price,
        "totalprice": totalprice,
        "name": name,
        "provserviceid": provserviceid,
        "id": id,
        "latinname": latinname,
        "carid": carid,
        "ispetrol": ispetrol,
      };
}

class Service {
  Service({
    this.image,
    this.name,
    this.id,
    this.latinname,
    this.parentid,
  });

  Uint8List? image;
  String? name;
  int? id;
  String? latinname;
  int? parentid;

  factory Service.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return Service(
      image: decodeApiImage(json["image"]),
      name: json["name"],
      id: json["id"],
      latinname: json["latinname"],
      parentid: json["parentid"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "name": name,
        "id": id,
        "latinname": latinname,
        "parentid": parentid,
      };
}

class Offer {
  Offer({
    this.servicerequestid,
    this.orderid,
    this.servicerequestofferid,
  });

  int? servicerequestid;
  int? orderid;
  int? servicerequestofferid;

  factory Offer.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return Offer(
      servicerequestid: json["servicerequestid"],
      orderid: json["orderid"],
      servicerequestofferid: json["servicerequestofferid"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "servicerequestid": servicerequestid,
        "orderid": orderid,
        "servicerequestofferid": servicerequestofferid,
      };
}

class ProviderInfo {
  ProviderInfo({
    this.image,
    this.branchid,
    this.description,
    this.servicesnames,
    this.phone,
    this.averagerate,
    this.name,
    this.latindesc,
    this.id,
    this.branchlatinname,
    this.latinname,
    this.email,
    this.fcmtoken,
    this.branchname,
  });

  Uint8List? image;
  int? branchid;
  String? description;
  List<Servicesname>? servicesnames;
  String? phone;
  int? averagerate;
  String? name;
  String? latindesc;
  int? id;
  String? branchlatinname;
  String? latinname;
  String? email;
  String? fcmtoken;
  String? branchname;

  factory ProviderInfo.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return ProviderInfo(
      image: decodeApiImage(json["image"]),
      branchid: json["branchid"],
      description: json["description"],
      servicesnames: (json["servicesnames"] as List? ?? [])
          .map((e) => Servicesname.fromJson(e))
          .toList(),
      phone: json["phone"],
      averagerate: json["averagerate"],
      name: json["name"],
      latindesc: json["latindesc"],
      id: json["id"],
      branchlatinname: json["branchlatinname"],
      latinname: json["latinname"],
      email: json["email"],
      fcmtoken: json["fcmtoken"],
      branchname: json["branchname"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "branchid": branchid,
        "description": description,
        "servicesnames": servicesnames?.map((e) => e.toJson()).toList() ?? [],
        "phone": phone,
        "averagerate": averagerate,
        "name": name,
        "latindesc": latindesc,
        "id": id,
        "branchlatinname": branchlatinname,
        "latinname": latinname,
        "email": email,
        "fcmtoken": fcmtoken,
        "branchname": branchname,
      };
}

class Servicesname {
  Servicesname({
    this.name,
    this.latinName,
  });

  String? name;
  String? latinName;

  factory Servicesname.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return Servicesname(
      name: json["name"],
      latinName: json["latinName"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "name": name,
        "latinName": latinName,
      };
}

class StatusHistory {
  StatusHistory({
    this.date,
    this.oldstatus,
    this.newstatus,
    this.changedbytype,
    this.orderid,
    this.changedbyid,
    this.id,
    this.changedbyname,
  });

  DateTime? date;
  int? oldstatus;
  int? newstatus;
  int? changedbytype;
  int? orderid;
  int? changedbyid;
  int? id;
  String? changedbyname;

  factory StatusHistory.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return StatusHistory(
      date: DateTime.tryParse('${json['date']}'),
      oldstatus: json["oldstatus"],
      newstatus: json["newstatus"],
      changedbytype: json["changedbytype"],
      orderid: json["orderid"],
      changedbyid: json["changedbyid"],
      id: json["id"],
      changedbyname: json["changedbyname"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "oldstatus": oldstatus,
        "newstatus": newstatus,
        "changedbytype": changedbytype,
        "orderid": orderid,
        "changedbyid": changedbyid,
        "id": id,
        "changedbyname": changedbyname,
      };
}

class User {
  User({
    this.image,
    this.phone,
    this.usertype,
    this.userid,
    this.email,
    this.fcmtoken,
    this.username,
  });

  Uint8List? image;
  String? phone;
  int? usertype;
  int? userid;
  String? email;
  String? fcmtoken;
  String? username;

  factory User.fromJson(Map<dynamic, dynamic> json) {
    json = ApiJson.object(json);
    return User(
      image: decodeApiImage(json["image"]),
      phone: json["phone"],
      usertype: json["usertype"],
      userid: json["userid"],
      email: json["email"],
      fcmtoken: json["fcmtoken"],
      username: json["username"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "phone": phone,
        "usertype": usertype,
        "userid": userid,
        "email": email,
        "fcmtoken": fcmtoken,
        "username": username,
      };
}
