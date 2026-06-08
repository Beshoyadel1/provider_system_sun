import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/brand_model_create_prov_service_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/car_model_create_prov_service_model.dart';

class CreateProvServiceRequest {
  final int? serviceid;
  final int? provid;
  final int? taxid;
  final String? name;
  final String? latinname;
  final double? unifiedprice;
  final double? cost;
  final bool? isunifiedprice;
  final List<BrandModelCreateProvServiceModel>? brands;
  final List<CarModelCreateProvServiceModel>? cars;

  CreateProvServiceRequest(
      {this.serviceid,
      this.provid,
      this.taxid,
      this.name,
      this.latinname,
      this.brands,
      this.cars,
      this.unifiedprice,
      this.cost,
      this.isunifiedprice});

  Map<String, dynamic> toJson() {
    return {
      "serviceid": serviceid,
      "provid": provid,
      "taxid": taxid,
      "name": name,
      "latinname": latinname,
      "brands": brands?.map((e) => e.toJson()).toList() ?? [],
      "cars": cars?.map((e) => e.toJson()).toList() ?? [],
      "unifiedprice": unifiedprice,
      "cost": cost,
      "isunifiedprice": isunifiedprice,
    };
  }
}
