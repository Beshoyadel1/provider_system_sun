import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/brand_model_create_prov_service_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/car_model_create_prov_service_model.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/create_prov_service_datasource/create_prov_service_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/create_prov_service_request/create_prov_service_request.dart';
import 'package:sun_web_system/features/service_settings/data/response/create_prov_service_response/create_prov_service_response.dart';
import 'package:sun_web_system/features/service_settings/data/response/get_prov_services_response/get_prov_services_response.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/features/service_settings/presentation/validation/service_price_validation.dart';
import 'create_prov_service_state.dart';

class CreateProvServiceCubit extends Cubit<CreateProvServiceState> {
  CreateProvServiceCubit() : super(CreateProvServiceInitial());

  final CreateProvServiceRepository _repository = CreateProvServiceRepository();

  /// 🔵 unified
  final Map<int, BrandModelCreateProvServiceModel> brandsData = {};

  /// 🟢 cars
  final List<CarModelCreateProvServiceModel> cars = [];

  /// 📌 radio
  final Map<int, int> brandSelection = {};

  /// 🧠 form لكل brand
  final Map<int, GlobalKey<FormState>> formKeys = {};

  int? serviceId;

  void _emitIfOpen(CreateProvServiceState state) {
    if (!isClosed) {
      emit(state);
    }
  }

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
    cars.removeWhere((e) => e.carbrandid == brandId && e.carmodelid == modelId);

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
    cars.removeWhere((e) => e.carbrandid == brandId && e.carmodelid == modelId);

    emit(CreateProvServiceInitial());
  }

  List<BrandModelCreateProvServiceModel> buildBrands() {
    return brandsData.values.toList();
  }

  void clearDetailedPricing() {
    brandsData.clear();
    cars.clear();
    brandSelection.clear();

    for (final key in formKeys.values) {
      key.currentState?.reset();
    }
  }

  Future<void> createProvService({
    required CreateProvServiceRequest request,
  }) async {
    if (isClosed) return;

    _emitIfOpen(CreateProvServiceLoading());

    try {
      if (serviceId == null) {
        _emitIfOpen(
          CreateProvServiceError(AppLanguageKeys.selectPricingTypeFirst),
        );
        return;
      }

      if (!_hasValidPricing(request)) {
        _emitIfOpen(
          CreateProvServiceError(AppLanguageKeys.costMustBeLessThanPrice),
        );
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
          unifiedprice: request.unifiedprice);

      print("📤 SENDING:");
      print(const JsonEncoder.withIndent(' ').convert(updatedRequest.toJson()));

      final createdResponse =
          await _repository.createProvService(request: updatedRequest);

      if (isClosed) return;

      final createdService = _buildCreatedService(
        response: createdResponse,
        request: updatedRequest,
      );

      brandsData.clear();
      cars.clear();
      brandSelection.clear();

      for (var key in formKeys.values) {
        key.currentState?.reset();
      }

      _emitIfOpen(CreateProvServiceSuccess(createdService));
    } catch (e) {
      _emitIfOpen(CreateProvServiceError(e.toString()));
    }
  }

  GetProvServicesResponse _buildCreatedService({
    required CreateProvServiceResponse response,
    required CreateProvServiceRequest request,
  }) {
    final brands = (request.brands ?? const []).map((brand) {
      final brandId = brand.id ?? 0;

      final models = (request.cars ?? const [])
          .where((car) => car.carbrandid == brandId)
          .map(
            (car) => ModelItem(
              id: car.id ?? 0,
              provserviceid: response.id,
              carbrandid: car.carbrandid ?? 0,
              carmodelid: car.carmodelid ?? 0,
              price: car.price ?? 0,
              cost: car.cost ?? 0,
            ),
          )
          .toList();

      return BrandItem(
        provServiceBrand: ProvServiceBrand(
          // The create endpoint does not return child row IDs. Zero keeps the
          // locally-created child distinguishable until the next screen load.
          id: 0,
          provserviceid: response.id,
          brandid: brandId,
          unifiedprice: brand.unifiedprice,
          isunifiedprice: brand.isunifiedprice ?? false,
          cost: brand.cost,
        ),
        models: models,
      );
    }).toList();

    return GetProvServicesResponse(
      provService: ProvService(
        id: response.id,
        serviceid: response.serviceId,
        provid: response.providerId,
        taxid: response.taxId,
        name: response.name,
        latinname: response.latinName,
        unifiedprice: response.unifiedPrice,
        cost: response.cost,
        isunifiedprice: response.isUnifiedPrice,
      ),
      brands: brands,
    );
  }

  bool _hasValidPricing(CreateProvServiceRequest request) {
    if (request.isunifiedprice == true &&
        !isCostLessThanPrice(
          cost: request.cost,
          price: request.unifiedprice,
        )) {
      return false;
    }

    for (final brand in request.brands ?? const []) {
      if (brand.isunifiedprice == true &&
          !isCostLessThanPrice(
            cost: brand.cost,
            price: brand.unifiedprice,
          )) {
        return false;
      }
    }

    for (final car in request.cars ?? const []) {
      if (!isCostLessThanPrice(cost: car.cost, price: car.price)) {
        return false;
      }
    }

    return true;
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
