import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/car_model_create_service_package_request.dart';

class CreateServicePackageRequest {
  final int? provId;
  final String? name;
  final String? latinName;
  final List<PackageItemRequest>? items;
  final int? taxId;
  final num? price;
  final num? cost;
  final List<int>? serviceIds;
  final List<SupportedCarRequest>? supportedCars;

  CreateServicePackageRequest({
    this.provId,
    this.name,
    this.latinName,
    this.items,
    this.taxId,
    this.price,
    this.cost,
    this.serviceIds,
    this.supportedCars,
  });

  Map<String, dynamic> toJson() {
    return {
      "provid": provId,
      "name": name,
      "latinname": latinName,
      "items": items?.map((e) => e.toJson()).toList(),
      "taxid": taxId,
      "price": price,
      "cost": cost,
      "serviceIds": serviceIds,
      "supportedCars":
      supportedCars?.map((e) => e.toJson()).toList(),
    };
  }
}

class PackageItemRequest {
  final int? packageId;
  final String? item;
  final String? latinItem;

  PackageItemRequest({
    this.packageId,
    this.item,
    this.latinItem,
  });

  Map<String, dynamic> toJson() {
    return {
      "packageid": packageId,
      "item": item,
      "latinitem": latinItem,
    };
  }
}

class SupportedCarRequest {
  final int? carBrandId;
  final List<int>? carModelIds;

  SupportedCarRequest({
    this.carBrandId,
    this.carModelIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "carbrandid": carBrandId,
      "carmodeliDs": carModelIds,
    };
  }
}