import 'package:sun_web_system/core/api_functions/general/tax/get_available_taxes_model/get_tax_model.dart';

abstract class GetTaxState {}

class GetTaxInitial extends GetTaxState {}

class GetTaxLoading extends GetTaxState {}

class GetTaxSuccess extends GetTaxState {
  final List<GetTaxModel> taxes;

  GetTaxSuccess(this.taxes);
}

class GetTaxError extends GetTaxState {
  final String message;

  GetTaxError(this.message);
}