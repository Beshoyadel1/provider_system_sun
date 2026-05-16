import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class SizeControllers {
  final TextEditingController nameController;
  final TextEditingController latinNameController;
  final TextEditingController priceController;
  final TextEditingController costController;

  SizeControllers({
    TextEditingController? nameController,
    TextEditingController? latinNameController,
    TextEditingController? priceController,
    TextEditingController? costController,
  })  : nameController = nameController ?? TextEditingController(),
        latinNameController = latinNameController ?? TextEditingController(),
        priceController = priceController ?? TextEditingController(),
        costController = costController ?? TextEditingController();
}