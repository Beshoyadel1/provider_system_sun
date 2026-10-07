import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/brand_model_create_prov_service_model.dart';

class CreateProvServiceRequest {
  final List<int>? branchIds;
  final int id;
  final int? serviceid;
  final int? provid;
  final int? taxid;
  final String? name;
  final String? latinname;
  final double? unifiedprice;
  final double? cost;
  final bool? isunifiedprice;
  final List<BrandModelCreateProvServiceModel>? brands;

  CreateProvServiceRequest({
    this.branchIds,
    this.id = 0,
    this.serviceid,
    this.provid,
    this.taxid,
    this.name,
    this.latinname,
    this.brands,
    this.unifiedprice,
    this.cost,
    this.isunifiedprice,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "serviceid": serviceid,
      if (branchIds != null) "branchIds": branchIds,
      "provid": provid,
      "taxid": taxid,
      "name": name,
      "latinname": latinname,
      "unifiedprice": unifiedprice,
      "isunifiedprice": isunifiedprice,
      "cost": cost,
      "brands": brands?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}
