import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:sun_web_system/core/api/dio_function/failures.dart';
import 'package:sun_web_system/core/api_functions/general/tax/get_available_taxes_model/get_available_taxes_repository.dart';
import 'package:sun_web_system/core/api_functions/general/tax/get_available_taxes_model/get_tax_model.dart';
import 'package:sun_web_system/features/service_settings/logic/get_tax_cubit/get_tax_state.dart';

class GetTaxCubit extends Cubit<GetTaxState> {
  GetTaxCubit() : super(GetTaxInitial());

  List<GetTaxModel> taxes = [];
  GetTaxModel? selectedTax;

  Future<void> getTax() async {
    emit(GetTaxLoading());

    try {
      final data = await getTaxFunction();
      taxes = data;
      emit(GetTaxSuccess(data));
    } catch (e) {
      final errorMessage = e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString();

      emit(GetTaxError(errorMessage));
    }
  }

  void selectTax(GetTaxModel tax) {
    selectedTax = tax;
    emit(GetTaxSuccess(taxes)); // refresh UI
  }
  void clearTax() {
    selectedTax = null;
    emit(GetTaxSuccess(taxes)); // refresh UI
  }
}