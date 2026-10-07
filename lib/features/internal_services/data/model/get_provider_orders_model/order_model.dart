import 'dart:typed_data';
import 'package:sun_web_system/core/utilies/api_image.dart';
import 'package:sun_web_system/features/internal_services/data/model/get_provider_orders_model/service_model.dart';
import 'package:sun_web_system/features/internal_services/data/model/get_provider_orders_model/service_package_model.dart';

class OrderModel {
  final int? id;
  final int? userId;
  final String? username;
  final int? userType;
  final int? orderStatus;
  final String? orderDate;
  final num? totalPrice;
  final int? providerId;
  final String? providerName;
  final String? providerLatinName;
  final Uint8List? providerImage;
  final String? branchName;
  final int? branchId;
  final String? branchLatinName;
  final List<ServiceModel>? services;
  final List<dynamic>? provServices;
  final List<ServicePackageModel>? servicePackages;
  final dynamic car;

  OrderModel({
     this.id,
     this.userId,
     this.username,
     this.userType,
     this.orderStatus,
     this.orderDate,
     this.totalPrice,
     this.providerId,
     this.providerName,
     this.providerLatinName,
     this.providerImage,
     this.branchName,
     this.branchId,
     this.branchLatinName,
     this.services,
     this.provServices,
     this.servicePackages,
     this.car,
  });

  /// Some orders have billed services but no category in `services`.
  /// Display their names without treating a provider service ID as a category ID.
  ServiceModel? get displayService {
    if (services?.isNotEmpty == true) return services!.first;
    if (provServices?.isNotEmpty == true && provServices!.first is Map) {
      final service = provServices!.first as Map;
      return ServiceModel(
        name: service['name']?.toString(),
        latinName: service['latinname']?.toString(),
      );
    }
    if (servicePackages?.isNotEmpty == true) {
      final package = servicePackages!.first;
      return ServiceModel(name: package.packageName, latinName: package.packageLatinName);
    }
    return null;
  }
  /// Merge only fields present in a push payload. Missing images/services retain
  /// their cached values because FCM deliberately sends a compact order object.
  OrderModel applyPatch(Map<String, dynamic> raw) {
    final p = {for (final e in raw.entries) e.key.toLowerCase(): e.value};
    int? number(String key, int? old) => int.tryParse('${p[key]}') ?? old;
    String? text(String key, String? old) => p[key]?.toString() ?? old;
    List<ServiceModel>? mergeServices() {
      if (p['services'] is! List) return services;
      return (p['services'] as List).whereType<Map>().map((rawService) {
        final incoming = {for (final e in rawService.entries) e.key.toString().toLowerCase(): e.value};
        final id = int.tryParse('${incoming['id']}');
        final matches = services?.where((s) => s.id == id);
        final previous = matches?.isNotEmpty == true ? matches!.first : null;
        return ServiceModel(
          id: id, parentId: int.tryParse('${incoming['parentid']}') ?? previous?.parentId,
          name: incoming['name']?.toString() ?? previous?.name,
          latinName: incoming['latinname']?.toString() ?? previous?.latinName,
          image: decodeApiImage(incoming['image']) ?? previous?.image,
        );
      }).toList();
    }
    return OrderModel(
      id: number('id', id), userId: number('userid', userId),
      username: text('username', username), userType: number('usertype', userType),
      orderStatus: number('orderstatus', orderStatus),
      orderDate: text('orderdate', orderDate),
      totalPrice: num.tryParse('${p['totalprice']}') ?? totalPrice,
      providerId: number('provid', providerId),
      providerName: text('provname', providerName),
      providerLatinName: text('provlatinname', providerLatinName),
      providerImage: providerImage,
      branchName: text('branchname', branchName),
      branchId: number('branchid', branchId),
      branchLatinName: text('branchlatinname', branchLatinName),
      services: mergeServices(),
      provServices: p['provservices'] is List ? p['provservices'] : provServices,
      servicePackages: p['servicepackages'] is List
          ? (p['servicepackages'] as List).whereType<Map>().map((item) =>
              ServicePackageModel.fromJson(Map<String, dynamic>.from(item))).toList()
          : servicePackages,
      car: p['car'] ?? car,
    );
  }
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      userId: json['userid'] ?? 0,
      username: json['username'] ?? '',
      userType: json['usertype'] ?? 0,
      orderStatus: json['orderstatus'] ?? 0,
      orderDate: json['orderdate'] ?? '',
      totalPrice: json['totalprice'] ?? 0,

      providerId: json['provid'] ?? 0,
      providerName: json['provname'] ?? '',
      providerLatinName: json['provlatinname'] ?? '',
      providerImage: decodeApiImage(json['provimage']),

      branchName: json['branchname'] ?? '',
      branchId: json['branchid'],
      branchLatinName: json['branchlatinname'] ?? '',

      services: (json['services'] as List? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .toList(),

      provServices: json['provServices'] ?? [],

      servicePackages: (json['servicePackages'] as List? ?? [])
          .map((e) => ServicePackageModel.fromJson(e))
          .toList(),

      car: json['car'],
    );
  }
}
