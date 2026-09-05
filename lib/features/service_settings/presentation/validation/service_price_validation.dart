import 'package:sun_web_system/core/language/language_constant.dart';

bool isCostLessThanPrice({
  required num? cost,
  required num? price,
}) {
  return cost != null && price != null && cost < price;
}

String? validateCostLessThanPrice({
  required String? costText,
  required String? priceText,
}) {
  if (costText == null || costText.trim().isEmpty) {
    return AppLanguageKeys.enterYourData;
  }

  final cost = double.tryParse(costText.trim());
  final price = double.tryParse(priceText?.trim() ?? '');

  if (cost == null) {
    return AppLanguageKeys.enterYourData;
  }

  // The price field has its own required validator.
  if (price == null) return null;

  if (!isCostLessThanPrice(cost: cost, price: price)) {
    return AppLanguageKeys.costMustBeLessThanPrice;
  }

  return null;
}
