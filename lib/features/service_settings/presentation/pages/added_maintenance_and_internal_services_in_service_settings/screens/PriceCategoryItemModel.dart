import 'package:flutter/cupertino.dart';

class PriceCategoryItemModel {
  final String name;
  final String image;
  final TextEditingController controller;

  PriceCategoryItemModel({
    required this.name,
    required this.image,
    required this.controller,
  });
}