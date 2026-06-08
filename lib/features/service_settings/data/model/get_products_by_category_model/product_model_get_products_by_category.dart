import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_all_product_categories_model/product_category_model.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';

class ProductModelGetProductsByCategory {
  final int id;
  final String? name;
  final String? latinName;
  final Uint8List? image;

  final int? price;
  final int? cost;
  final int? inStock;

  final String? description;
  final String? latinDesc;
  final String? instructions;

  final bool? isNew;
  final int? taxId;
  final int? productCategoryId;

  final ProductCategoryModel? category;
  final ProviderModel? provider;

  final List<BrandModel> brands;
  final List<ProductSizeModel> sizes;

  ProductModelGetProductsByCategory({
    required this.id,
    this.name,
    this.latinName,
    this.image,
    this.price,
    this.cost,
    this.inStock,
    this.description,
    this.latinDesc,
    this.instructions,
    this.isNew,
    this.taxId,
    this.productCategoryId,
    this.category,
    this.provider,
    required this.brands,
    required this.sizes,
  });

  factory ProductModelGetProductsByCategory.fromJson(
      Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return ProductModelGetProductsByCategory(
      id: data['id'] ?? 0,
      name: data['name']?.toString() ?? "",
      latinName: data['latinname']?.toString() ?? "",
      image: _decodeImage(data['image']),
      price: data['price'] ?? 0,
      cost: data['cost'] ?? 0,
      inStock: data['instock'] ?? 0,
      description: data['description']?.toString() ?? "",
      latinDesc: data['latindesc']?.toString() ?? "",
      instructions: data['instructions']?.toString() ?? "",
      isNew: data['isnew'] ?? false,
      taxId: data['taxid'] ?? 0,
      productCategoryId: data['productcategoryid'] ?? 0,
      category: data['productCategory'] != null
          ? ProductCategoryModel.fromJson(
              data['productCategory'] as Map<String, dynamic>)
          : null,
      provider: data['provider'] != null
          ? ProviderModel.fromJson(data['provider'] as Map<String, dynamic>)
          : null,
      brands: (data['brands'] as List<dynamic>?)
              ?.map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sizes: (data['sizes'] as List<dynamic>?)
              ?.map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static Uint8List? _decodeImage(String? base64String) {
    if (base64String == null) {
      return null;
    }

    try {
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  String getName(BuildContext context) {
    final isArabic = LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? (name ?? "") : (latinName ?? "");
  }

  String getDescription(BuildContext context) {
    final isArabic = LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? (description ?? "") : (latinDesc ?? "");
  }
}

class BrandModel {
  final int? brandId;
  final String? brandName;
  final String? brandLatinName;
  final Uint8List? image;

  final List<CarModel> models;

  BrandModel({
    this.brandId,
    this.brandName,
    this.brandLatinName,
    this.image,
    required this.models,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandId: json['brandid'] ?? 0,
      brandName: json['brandname']?.toString() ?? "",
      brandLatinName: json['brandlatinname']?.toString() ?? "",
      image: ProductModelGetProductsByCategory._decodeImage(json['image']),
      models: (json['models'] as List<dynamic>?)
              ?.map((e) => CarModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String getBrandName(BuildContext context) {
    final isArabic = LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? (brandName ?? "") : (brandLatinName ?? "");
  }
}

class CarModel {
  final int? modelId;
  final String? modelName;
  final Uint8List? image;

  CarModel({
    this.modelId,
    this.modelName,
    this.image,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      modelId: json['modelid'] ?? 0,
      modelName: json['modelname']?.toString() ?? "",
      image: ProductModelGetProductsByCategory._decodeImage(json['image']),
    );
  }
}

class ProviderModel {
  final int? id;
  final String? name;
  final String? latinName;
  final Uint8List? image;

  ProviderModel({
    this.id,
    this.name,
    this.latinName,
    this.image,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? "",
      latinName: json['latinname']?.toString() ?? "",
      image: ProductModelGetProductsByCategory._decodeImage(json['image']),
    );
  }
}

class ProductSizeModel {
  final int? id;
  final String? name;
  final String? latinName;
  final int? price;
  final int? cost;

  ProductSizeModel({
    this.id,
    this.name,
    this.latinName,
    this.price,
    this.cost,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? "",
      latinName: json['latinname']?.toString() ?? "",
      price: json['price'] ?? 0,
      cost: json['cost'] ?? 0,
    );
  }
}
