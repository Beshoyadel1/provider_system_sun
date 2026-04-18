import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/brand_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'create_prov_service_state.dart';
import '../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import '../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_repository.dart';


class CreateProvServiceCubit extends Cubit<CreateProvServiceState> {
  CreateProvServiceCubit() : super(CreateProvServiceInitial());

  final CreateProvServiceRepository _repository =
  CreateProvServiceRepository();

  /// 🔵 unified
  final Map<int, BrandModelCreateProvServiceRequest> brandsData = {};

  /// 🟢 cars
  final List<CarModelCreateProvServiceRequest> cars = [];

  /// 📌 radio
  final Map<int, int> brandSelection = {};

  /// 🧠 form لكل brand
  final Map<int, GlobalKey<FormState>> formKeys = {};

  int? serviceId;

  void setService({required int id}) {
    serviceId = id;
  }

  /// 🔘 radio
  void setBrandSelection({
    required int brandId,
    required int option,
  }) {
    brandSelection[brandId] = option;
    brandsData[brandId] = BrandModelCreateProvServiceRequest(
      id: brandId,
      isuniformprice: false,
    );

    emit(CreateProvServiceInitial());
  }

  void setUnifiedPrice({
    required int brandId,
    required double price,
    required double cost,
  }) {
    brandsData[brandId] = BrandModelCreateProvServiceRequest(
      id: brandId,
      uniformprice: price,
      isuniformprice: true,
      cost: cost,
    );

    emit(CreateProvServiceInitial());
  }

  void setCarData({
    required int brandId,
    required int modelId,
    required double price,
    required double cost,
  }) {
    cars.removeWhere((e) =>
    e.carbrandid == brandId && e.carmodelid == modelId);

    cars.add(
      CarModelCreateProvServiceRequest(
        id: 0,
        carbrandid: brandId,
        carmodelid: modelId,
        price: price,
        cost: cost,
      ),
    );
  }

  List<BrandModelCreateProvServiceRequest> buildBrands() {
    return brandsData.values.toList();
  }

  Future<void> createProvService({
    required CreateProvServiceRequest request,
  }) async {
    emit(CreateProvServiceLoading());

    try {
      if (serviceId == null) {
        emit(CreateProvServiceError(AppLanguageKeys.selectPricingTypeFirst));
        return;
      }

      final user = await AuthLocalStorage.getUser();

      final updatedRequest = CreateProvServiceRequest(
        serviceid: serviceId!,
        provid: user?.userid ?? 5,
        taxid: request.taxid,
        name: "",
        latinname: "",
        brands: request.brands,
        cars: request.cars,
      );

      print("📤 SENDING:");
      print(const JsonEncoder.withIndent(' ')
          .convert(updatedRequest.toJson()));

      await _repository.createProvService(request: updatedRequest);

      brandsData.clear();
      cars.clear();
      brandSelection.clear();

      for (var key in formKeys.values) {
        key.currentState?.reset();
      }

      emit(CreateProvServiceSuccess());
    } catch (e) {
      emit(CreateProvServiceError(e.toString()));
    }
  }
}