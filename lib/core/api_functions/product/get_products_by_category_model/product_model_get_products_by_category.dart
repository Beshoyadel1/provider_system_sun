import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';

class ProductModelGetProductsByCategory {
  final int id;
  final String? name;
  final String? latinName;
  final Uint8List? image;
  final int? price;
  final int? inStock;
  final ProductCategory? category;
  final List<BrandModel> brands;

  ProductModelGetProductsByCategory({
    required this.id,
    this.name,
    this.latinName,
    this.image,
    this.price,
    this.inStock,
    this.category,
    required this.brands,
  });

  factory ProductModelGetProductsByCategory.fromJson(Map<String, dynamic> json) {
    return ProductModelGetProductsByCategory(
      id: json['id'],
      name: json['name'],
      latinName: json['latinname'],
      image: _decodeImage(json['image']),
      price: json['price'],
      inStock: json['instock'],
      category: json['productCategory'] != null
          ? ProductCategory.fromJson(json['productCategory'])
          : null,
      brands: (json['brands'] as List?)
          ?.map((e) => BrandModel.fromJson(e))
          .toList() ??
          [],
    );
  }
  static Uint8List? _decodeImage(String? base64String) {
    if (base64String == null) return null;
    try {
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  String getName(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? (name ?? "") : (latinName ?? "");
  }

  String getCategoryName(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic
        ? (category?.name ?? "")
        : (category?.latinName ?? "");
  }

  String getBrandName(BuildContext context) {
    if (brands.isEmpty) return "";

    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic
        ? (brands.first.brandName ?? "")
        : (brands.first.brandLatinName ?? "");
  }
}
class BrandModel {
  final String? brandName;
  final String? brandLatinName;
  final Uint8List? image;

  BrandModel({
    this.brandName,
    this.brandLatinName,
    this.image,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandName: json['brandname'],
      brandLatinName: json['brandlatinname'],
      image: ProductModelGetProductsByCategory._decodeImage(json['image']),
    );
  }
}
class ProductCategory {
  final String? name;
  final String? latinName;
  final Uint8List? image;

  ProductCategory({this.name, this.latinName, this.image});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'],
      latinName: json['latinName'],
      image: ProductModelGetProductsByCategory._decodeImage(json['image']),
    );
  }
}