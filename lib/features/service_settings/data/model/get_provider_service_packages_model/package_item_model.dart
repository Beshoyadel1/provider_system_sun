import 'package:flutter/material.dart';

class PackageItemModel {
  final int packageId;
  final String item;
  final String latinItem;

  PackageItemModel({
    required this.packageId,
    required this.item,
    required this.latinItem,
  });

  factory PackageItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PackageItemModel(
      packageId: json["packageid"] ?? 0,
      item: json["item"] ?? "",
      latinItem: json["latinitem"] ?? "",
    );
  }

  String getLocalizedName(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return lang == 'ar'
        ? item
        : latinItem;
  }
}