import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:sun_web_system/core/api/dio_function/failures.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_available_taxes_datasource/get_available_taxes_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_available_taxes_model/get_tax_model.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_state.dart';

class GetTaxCubit extends Cubit<GetTaxState> {
  GetTaxCubit({Future<List<GetTaxModel>> Function()? taxesLoader})
      : _taxesLoader = taxesLoader ?? getTaxFunction,
        super(GetTaxInitial());

  final Future<List<GetTaxModel>> Function() _taxesLoader;
  int _requestVersion = 0;

  List<GetTaxModel> taxes = [];
  GetTaxModel? selectedTax;

  Future<void> getTaxAndSelect(int taxId) => _load(taxId: taxId);

  Future<void> getTax() => _load();

  Future<void> _load({int? taxId}) async {
    if (isClosed) return;
    final requestVersion = ++_requestVersion;
    emit(GetTaxLoading());

    try {
      final data = await _taxesLoader();
      if (isClosed || requestVersion != _requestVersion) return;
      taxes = data;
      final selectedId = taxId ?? selectedTax?.taxId;
      selectedTax = null;
      for (final tax in taxes) {
        if (tax.taxId == selectedId) selectedTax = tax;
      }
      if (taxId != null && selectedTax == null && taxes.isNotEmpty) {
        selectedTax = taxes.first;
      }
      emit(GetTaxSuccess(taxes, selectedTax: selectedTax));
    } catch (e) {
      if (isClosed || requestVersion != _requestVersion) return;
      final errorMessage = e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString();

      emit(GetTaxError(errorMessage));
    }
  }

  void selectTax(GetTaxModel tax) {
    if (isClosed) return;
    selectedTax = tax;
    emit(GetTaxSuccess(taxes, selectedTax: selectedTax));
  }

  void selectTaxById(int id) {
    if (isClosed) return;
    try {
      selectedTax = taxes.firstWhere((e) => e.taxId == id);
      emit(GetTaxSuccess(taxes, selectedTax: selectedTax));
    } catch (_) {}
  }

  void clearTax() {
    if (isClosed) return;
    selectedTax = null;
    emit(GetTaxSuccess(taxes));
  }
}
