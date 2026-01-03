import 'dart:ui';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';

class ChartDataModel {
  final String label;
  final int percentage;
  final Color color;
  ChartDataModel({
    required this.label,
    required this.percentage,
    required this.color,
  });
}


final List<ChartDataModel> data = [
  ChartDataModel(
    label: AppLanguageKeys.internalMaintenanceKey,
    percentage: 60,
    color: AppColors.orangeColor,
  ),
  ChartDataModel(
    label: AppLanguageKeys.sparePartsKey,
    percentage: 30,
    color: AppColors.lightBlueColor,
  ),
  ChartDataModel(
    label: AppLanguageKeys.mobileServicesKey,
    percentage: 10,
    color:AppColors.darkGreyColor ,
  ),
];