import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/brand_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'create_prov_service_state.dart';
import '../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import '../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_repository.dart';


class CreateProvServiceCubit extends Cubit<CreateProvServiceState> {
  CreateProvServiceCubit() : super(CreateProvServiceInitial());

  final CreateProvServiceRepository _repository =
  CreateProvServiceRepository();

  List<BrandModelCreateProvServiceRequest> buildBrands() {
    return selectedBrandIds.map((brandId) {
      return BrandModelCreateProvServiceRequest(
        id: brandId,
        uniformprice: 0,
        isuniformprice: false,
        cost: 0,
      );
    }).toList();
  }

  final List<CarModelCreateProvServiceRequest> cars = [];

  final Set<int> selectedBrandIds = {};
  void printGroupedCars() {
    print("📦 RESULT:");

    if (cars.isEmpty) {
      print("❌ No Data");
      return;
    }

    final Map<int, List<CarModelCreateProvServiceRequest>> grouped = {};

    for (var car in cars) {
      grouped.putIfAbsent(car.carbrandid ?? 0, () => []);
      grouped[car.carbrandid]!.add(car);
    }

    grouped.forEach((brandId, models) {
      String line = "brandId {$brandId} = ";

      for (var m in models) {
        line += "modelId {${m.carmodelid}} cost {${m.cost}}, ";
      }

      print(line);
    });
  }
  void setCarPrice({
    required int brandId,
    required int modelId,
    required double price,
  }) {
    cars.removeWhere((e) =>
    e.carbrandid == brandId && e.carmodelid == modelId);

    cars.add(
      CarModelCreateProvServiceRequest(
        id: 0,
        carbrandid: brandId,
        carmodelid: modelId,
        price: price,
        cost: 0,
      ),
    );

    selectedBrandIds.add(brandId);


  }

  int? serviceId;
  String? name;
  String? latinName;

  void setService({
    required int id,
  }) {
    serviceId = id;
  }

  Future<void> createProvService({
    required CreateProvServiceRequest request,
  }) async {
    emit(CreateProvServiceLoading());

    try {

      if (serviceId == null) {
        emit(CreateProvServiceError("Please select service first"));
        return;
      }

      final user = await AuthLocalStorage.getUser();

      final updatedRequest = CreateProvServiceRequest(
        serviceid: serviceId!,
        provid: user?.userid ?? 5,
        taxid: request.taxid,
        name: name ?? "",
        latinname: latinName ?? "",
        brands: request.brands,
        cars: request.cars,
      );

      print("📤 SENDING:");
      print(const JsonEncoder.withIndent('')
          .convert(updatedRequest.toJson()));

      await _repository.createProvService(request: updatedRequest);


      emit(CreateProvServiceSuccess());
    } catch (e) {
      emit(CreateProvServiceError(e.toString()));
    }
  }
}