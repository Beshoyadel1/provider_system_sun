import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/brand_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';

class CreateProvServiceRequest {
  final int? serviceId;
  final int? provId;
  final int? taxId;
  final String? name;
  final String? latinName;
  final List<BrandModelCreateProvServiceRequest>? brands;
  final List<CarModelCreateProvServiceRequest>? cars;

  CreateProvServiceRequest({
    required this.serviceId,
    required this.provId,
    required this.taxId,
    required this.name,
    required this.latinName,
    required this.brands,
    required this.cars,
  });

  Map<String, dynamic> toJson() => {
    "serviceid": serviceId,
    "provid": provId,
    "taxid": taxId,
    "name": name,
    "latinname": latinName,
    "brands": brands?.map((e) => e.toJson()).toList(),
    "cars": cars?.map((e) => e.toJson()).toList(),
  };
}