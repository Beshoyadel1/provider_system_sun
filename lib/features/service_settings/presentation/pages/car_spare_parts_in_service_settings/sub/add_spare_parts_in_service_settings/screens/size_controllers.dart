import 'package:flutter/material.dart';
import 'product_stock_controller.dart';

class SizeControllers {
  final int? id;
  final List<ProductStockController> stocks;
  final TextEditingController nameController;
  final TextEditingController latinNameController;
  final TextEditingController priceController;
  final TextEditingController costController;

  SizeControllers({
    this.id,
    List<ProductStockController>? stocks,
    TextEditingController? nameController,
    TextEditingController? latinNameController,
    TextEditingController? priceController,
    TextEditingController? costController,
  })  : stocks = stocks ?? [],
        nameController = nameController ?? TextEditingController(),
        latinNameController = latinNameController ?? TextEditingController(),
        priceController = priceController ?? TextEditingController(),
        costController = costController ?? TextEditingController();

  void dispose() {
    nameController.dispose();
    latinNameController.dispose();
    priceController.dispose();
    costController.dispose();
    for (final stock in stocks) {
      stock.dispose();
    }
  }
}
