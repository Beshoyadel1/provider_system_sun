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

  final num? price;
  final num? cost;
  final int? inStock;
  final int? totalStock;
  final List<int> branchIds;
  final List<ProductBranchStock> branchStocks;

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
    this.totalStock,
    this.branchIds = const [],
    this.branchStocks = const [],
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
    final stocks = _readStocks(data['branchStocks']);

    return ProductModelGetProductsByCategory(
      id: data['id'] ?? 0,
      name: data['name']?.toString() ?? "",
      latinName: data['latinname']?.toString() ?? "",
      image: _decodeImage(data['image']),
      price: _readNumber(data['price']) ?? 0,
      cost: _readNumber(data['cost']) ?? 0,
      inStock: _readInt(data['instock'] ?? data['inStock']),
      totalStock: _readInt(data['totalStock']),
      branchStocks: stocks,
      branchIds: _readIds(data['branchIds']),
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
              ?.map((e) => ProductSizeModel.fromJson(
                    e as Map<String, dynamic>,
                    productStocks: stocks,
                  ))
              .toList() ??
          [],
    );
  }

  // Trust the API's aggregate. Products with sizes use size stock only.
  int get displayStock => totalStock ?? inStock ?? 0;

  List<ProductBranchStock> get generalBranchStocks =>
      branchStocks.where((stock) => stock.sizeId == null).toList();

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
  final int? productId;
  final int? providerId;
  final String? name;
  final String? latinName;
  final num? price;
  final num? cost;
  final int? inStock;
  final List<int> branchIds;
  final List<ProductBranchStock> branchStocks;

  ProductSizeModel({
    this.id,
    this.productId,
    this.providerId,
    this.name,
    this.latinName,
    this.price,
    this.cost,
    this.inStock,
    this.branchIds = const [],
    this.branchStocks = const [],
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json,
      {List<ProductBranchStock> productStocks = const []}) {
    final id = _readInt(json['id']);
    return ProductSizeModel(
      id: id,
      productId: _readInt(json['productid'] ?? json['productId']),
      providerId: _readInt(json['provid'] ?? json['providerId']),
      name: json['name']?.toString() ?? "",
      latinName: json['latinname']?.toString() ?? "",
      price: _readNumber(json['price']) ?? 0,
      cost: _readNumber(json['cost']) ?? 0,
      inStock: _readInt(json['inStock'] ?? json['instock']),
      branchIds: _readIds(json['branchIds']),
      branchStocks: json['branchStocks'] is List
          ? _readStocks(json['branchStocks'])
          : productStocks
              .where((stock) => id != null && stock.sizeId == id)
              .toList(),
    );
  }
}

class ProductBranchStock {
  final int branchId;
  final int? sizeId;
  final String branchName;
  final String branchLatinName;
  final int inStock;
  final bool isActive;

  const ProductBranchStock({
    required this.branchId,
    this.sizeId,
    this.branchName = '',
    this.branchLatinName = '',
    required this.inStock,
    required this.isActive,
  });

  factory ProductBranchStock.fromJson(Map<String, dynamic> json) =>
      ProductBranchStock(
        branchId: _readInt(json['branchId']) ?? 0,
        // Zero is a real size ID in the observed API response, unlike null.
        sizeId: _readInt(json['sizeId']),
        branchName: json['branchName']?.toString() ?? '',
        branchLatinName: json['branchLatinName']?.toString() ?? '',
        inStock: _readInt(json['inStock']) ?? 0,
        isActive: json['isActive'] == true,
      );

  String getBranchName(bool isArabic) {
    final preferred = isArabic ? branchName : branchLatinName;
    final fallback = isArabic ? branchLatinName : branchName;
    return preferred.isNotEmpty
        ? preferred
        : fallback.isNotEmpty
            ? fallback
            : '${isArabic ? 'فرع' : 'Branch'} #$branchId';
  }
}

num? _readNumber(dynamic value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
int? _readInt(dynamic value) => _readNumber(value)?.toInt();
List<int> _readIds(dynamic value) => value is List
    ? value.map(_readInt).whereType<int>().toSet().toList()
    : const [];
List<ProductBranchStock> _readStocks(dynamic value) => value is List
    ? value
        .whereType<Map>()
        .map((item) =>
            ProductBranchStock.fromJson(Map<String, dynamic>.from(item)))
        .toList()
    : const [];
