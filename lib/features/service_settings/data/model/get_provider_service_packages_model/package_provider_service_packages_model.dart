import 'package:flutter/cupertino.dart';

class PackageProviderServicePackagesModel {
  final int id;
  final int provId;
  final String name;
  final String latinName;
  final num price;
  final int taxId;
  final num cost;

  PackageProviderServicePackagesModel({
    required this.id,
    required this.provId,
    required this.name,
    required this.latinName,
    required this.price,
    required this.taxId,
    required this.cost,
  });

  factory PackageProviderServicePackagesModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PackageProviderServicePackagesModel(
      id: json['id'] ?? 0,
      provId: json['provid'] ?? 0,
      name: json['name'] ?? '',
      latinName: json['latinname'] ?? '',
      price: json['price'] ?? 0,
      taxId: json['taxid'] ?? 0,
      cost: json['cost'] ?? 0,
    );
  }

  String getLocalizedName(BuildContext context) {
    final lang =
        Localizations.localeOf(context).languageCode;

    return lang == 'ar'
        ? name
        : latinName;
  }
}