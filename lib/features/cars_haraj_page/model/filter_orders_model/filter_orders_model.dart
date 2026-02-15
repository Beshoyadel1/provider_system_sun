import 'package:sun_web_system/core/language/language_constant.dart';

class filterOrdersModel {
  final String text;
  bool isSelected;

  filterOrdersModel({required this.text, this.isSelected = false});
}

final List<filterOrdersModel> filterOrders = [
  filterOrdersModel(text: AppLanguageKeys.allOrdersKey, isSelected: true),
  filterOrdersModel(text: AppLanguageKeys.newOrdersKey),
  filterOrdersModel(text: AppLanguageKeys.completedOrdersKey),
  filterOrdersModel(text: AppLanguageKeys.underServiceKey),
];

final List<filterOrdersModel> filterOptionsCars = [
  filterOrdersModel(text: 'جميع السيارات', isSelected: true),
  filterOrdersModel(text: 'سيارات جديدة'),
  filterOrdersModel(text: 'سيارات مستعملة'),
  filterOrdersModel(text: 'سيارة مباعة'),
];
