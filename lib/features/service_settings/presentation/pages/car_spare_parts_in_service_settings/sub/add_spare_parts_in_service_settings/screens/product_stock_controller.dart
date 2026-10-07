import 'package:flutter/material.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/data/request/create_product_request/create_product_request.dart';

class ProductStockController {
  final int branchId;
  final String? branchName;
  final String? branchLatinName;
  final TextEditingController quantity;
  bool isActive;

  ProductStockController(
      {required this.branchId,
      this.branchName,
      this.branchLatinName,
      int inStock = 0,
      this.isActive = true})
      : quantity = TextEditingController(text: inStock.toString());

  factory ProductStockController.fromStock(ProductBranchStock stock) =>
      ProductStockController(
          branchId: stock.branchId,
          branchName: stock.branchName,
          branchLatinName: stock.branchLatinName,
          inStock: stock.inStock,
          isActive: stock.isActive);

  ProductStockRequest toRequest() => ProductStockRequest(
      branchId: branchId,
      inStock: int.parse(quantity.text.trim()),
      isActive: isActive);

  void dispose() => quantity.dispose();
}
