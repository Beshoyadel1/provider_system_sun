import 'package:sun_web_system/features/service_settings/data/model/create_prov_service_model/brand_model_create_prov_service_model.dart';

class UpdateProvServiceRequest {
  final List<int>? branchIds;
  final int? id;
  final int? serviceId;
  final int? provId;
  final int? taxId;
  final String? name;
  final String? latinName;
  final double? uniformprice;
  final double? cost;
  final bool? isuniformprice;
  final List<BrandModelCreateProvServiceModel>? brands;

  UpdateProvServiceRequest({
    this.branchIds,
    this.id,
    this.serviceId,
    this.provId,
    this.taxId,
    this.name,
    this.latinName,
    this.brands,
    this.cost,
    this.uniformprice,
    this.isuniformprice,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceid": serviceId,
        if (branchIds != null) "branchIds": branchIds,
        "provid": provId,
        "taxid": taxId,
        "name": name,
        "latinname": latinName,
        "unifiedprice": uniformprice,
        "isunifiedprice": isuniformprice,
        "cost": cost,
        "brands": brands?.map((e) => e.toJson()).toList() ?? [],
      };
}
