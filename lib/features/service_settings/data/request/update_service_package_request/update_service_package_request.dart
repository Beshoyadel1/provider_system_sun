import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/create_service_package_request.dart';

class UpdateServicePackageRequest {
  final int? id;
  final int? provId;
  final String? name;
  final String? latinName;
  final List<PackageItemRequest>? items;
  final int? taxId;
  final num? price;
  final num? cost;
  final List<int>? serviceIds;
  final List<SupportedCarRequest>? supportedCars;

  UpdateServicePackageRequest({
    this.id,
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
      "id": id,
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