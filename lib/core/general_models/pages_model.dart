import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../language/language_cubit/language_cubit.dart';

class PageNodeModel {
  final String name;
  final String? latinName;
  final int number;
  final String? image;
  final Uint8List? imageUint8List;

  final Widget? page;
  final List<PageNodeModel> children;

  const PageNodeModel({
    required this.name,
    this.latinName,
    required this.number,
    this.image,
    this.page,
    this.imageUint8List,
    this.children = const [],
  });

  String getName(BuildContext context) => latinName == null
      ? name
      : LanguageCubit.localizedValue(context, name, latinName);
}

class PageNodeWithIDModel {
  final String name;
  final String? latinName;
  final int number;
  final Widget? page;
  final int id;

  const PageNodeWithIDModel({
    required this.name,
    this.latinName,
    required this.number,
    this.page,
    required this.id,
  });

  String getName(BuildContext context) => latinName == null
      ? name
      : LanguageCubit.localizedValue(context, name, latinName);
}
