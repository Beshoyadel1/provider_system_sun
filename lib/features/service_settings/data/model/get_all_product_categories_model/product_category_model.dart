import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import '../../../../../core/language/language_cubit/language_cubit.dart';

class ProductCategoryModel {
  final int? id;
  final String? name;
  final String? latinName;
  final Uint8List? image;

  ProductCategoryModel({
    this.id,
    this.name,
    this.latinName,
    this.image,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return ProductCategoryModel(
      id: data['id'] ?? 0,
      name: data['name']?.toString() ?? "",
      latinName: (data['latinName'] ?? data['latinname'])?.toString() ?? "",
      image: _decodeImage(data['image']),
    );
  }

  static Uint8List? _decodeImage(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    try {
      return base64Decode(value);
    } on FormatException {
      return null;
    }
  }

  String getName(BuildContext context) {
    final isArabic = LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? (name ?? "") : (latinName ?? "");
  }
}
