import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/brand_model_create_prov_service_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/car_model_create_prov_service_model.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/create_prov_service_datasource/create_prov_service_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/create_prov_service_request/create_prov_service_request.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'create_prov_service_state.dart';


class CreateProvServiceCubit extends Cubit<CreateProvServiceState> {
  CreateProvServiceCubit() : super(CreateProvServiceInitial());

  final CreateProvServiceRepository _repository =
  CreateProvServiceRepository();

  /// 🔵 unified
  final Map<int, BrandModelCreateProvServiceModel> brandsData = {};

  /// 🟢 cars
  final List<CarModelCreateProvServiceModel> cars = [];

  /// 📌 radio
  final Map<int, int> brandSelection = {};

  /// 🧠 form لكل brand
  final Map<int, GlobalKey<FormState>> formKeys = {};

  int? serviceId;

  void removeBrandData(int brandId) {
    brandsData.remove(brandId);
    emit(CreateProvServiceInitial());
  }
  void setService({required int id}) {
    serviceId = id;
  }

  void setBrandSelection({
    required int brandId,
    required int option,
  }) {
    if (option == -1) {
      brandSelection.remove(brandId);
      brandsData.remove(brandId);

      cars.removeWhere((e) => e.carbrandid == brandId);

      emit(CreateProvServiceInitial());
      return;
    }

    brandSelection[brandId] = option;

    if (option == 1) {
      brandsData.remove(brandId);
      brandsData[brandId] = BrandModelCreateProvServiceModel(
        id: brandId,
        isunifiedprice: false,
      );
    }

    if (option == 0) {
      cars.removeWhere((e) => e.carbrandid == brandId);
    }

    emit(CreateProvServiceInitial());
  }

  void setUnifiedPrice({
    required int brandId,
    double? price,
    double? cost,
  }) {
    if (price == null && cost == null) {
      brandsData.remove(brandId);
      emit(CreateProvServiceInitial());
      return;
    }

    brandsData[brandId] = BrandModelCreateProvServiceModel(
      id: brandId,
      unifiedprice: price,
      cost: cost,
      isunifiedprice: true,
    );

    emit(CreateProvServiceInitial());
  }


  void setCarData({
    required int brandId,
    required int modelId,
    double? price,
    double? cost,
  }) {
    cars.removeWhere((e) =>
    e.carbrandid == brandId && e.carmodelid == modelId);

    cars.add(
      CarModelCreateProvServiceModel(
        id: 0,
        carbrandid: brandId,
        carmodelid: modelId,
        price: price,
        cost: cost,
      ),
    );
  }

  void removeCarData({
    required int brandId,
    required int modelId,
  }) {
    cars.removeWhere((e) =>
    e.carbrandid == brandId && e.carmodelid == modelId);

    emit(CreateProvServiceInitial());
  }

  List<BrandModelCreateProvServiceModel> buildBrands() {
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
        name: request.name,
        latinname: request.latinname,
        brands: request.brands,
        cars: request.cars,
        isunifiedprice: request.isunifiedprice,
        cost: request.cost,
        unifiedprice: request.unifiedprice
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
  void initFromApi(Map<String, dynamic> data) {
    brandsData.clear();
    cars.clear();
    brandSelection.clear();

    for (var b in data["brands"]) {
      final brandId = b["brandId"]; // 👈 نستخدم brand الحقيقي

      brandsData[brandId] = BrandModelCreateProvServiceModel(
        id: b["id"], // 👈 provServiceBrand.id
        unifiedprice: b["unifiedprice"],
        cost: b["cost"],
        isunifiedprice: b["isunifiedprice"],
      );

      /// تحديد نوع السعر
      if (b["isunifiedprice"] == true) {
        brandSelection[brandId] = 0;
      } else {
        brandSelection[brandId] = 1;
      }
    }

    /// 🔥 cars
    for (var c in data["cars"]) {
      cars.add(
        CarModelCreateProvServiceModel(
          id: c["id"],
          carbrandid: c["carbrandid"],
          carmodelid: c["carmodelid"],
          price: c["price"],
          cost: c["cost"],
        ),
      );
    }

    emit(CreateProvServiceInitial());
  }
}