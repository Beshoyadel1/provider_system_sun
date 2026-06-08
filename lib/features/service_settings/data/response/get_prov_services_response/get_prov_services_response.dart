class GetProvServicesResponse {

  final ProvService provService;
  final List<BrandItem> brands;

  GetProvServicesResponse({
    required this.provService,
    required this.brands,
  });

  factory GetProvServicesResponse.fromJson(
      Map<String, dynamic> json) {

    return GetProvServicesResponse(

      provService:
      json['provService'] != null
          ? ProvService.fromJson(
          json['provService']
          as Map<String, dynamic>)
          : ProvService.fromJson({}),

      brands:
      (json['brands'] as List<dynamic>?)
          ?.map((e) => BrandItem.fromJson(
          e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class ProvService {

  final int id;
  final int serviceid;
  final int provid;
  final int taxid;

  final String name;
  final String latinname;

  final double unifiedprice;
  final double cost;

  final bool isunifiedprice;

  ProvService({
    required this.id,
    required this.serviceid,
    required this.provid,
    required this.taxid,
    required this.name,
    required this.latinname,
    required this.unifiedprice,
    required this.cost,
    required this.isunifiedprice,
  });

  factory ProvService.fromJson(
      Map<String, dynamic> json) {

    return ProvService(

      id:
      json['id'] ?? 0,

      serviceid:
      json['serviceid'] ?? 0,

      provid:
      json['provid'] ?? 0,

      taxid:
      json['taxid'] ?? 0,

      name:
      json['name']?.toString() ?? "",

      latinname:
      json['latinname']?.toString() ?? "",

      unifiedprice:
      (json['unifiedprice'] as num?)
          ?.toDouble() ??
          0.0,

      cost:
      (json['cost'] as num?)
          ?.toDouble() ??
          0.0,

      isunifiedprice:
      json['isunifiedprice'] ?? false,
    );
  }
}

class BrandItem {

  final ProvServiceBrand provServiceBrand;
  final List<ModelItem> models;

  BrandItem({
    required this.provServiceBrand,
    required this.models,
  });

  factory BrandItem.fromJson(
      Map<String, dynamic> json) {

    return BrandItem(

      provServiceBrand:
      json['provServiceBrand'] != null
          ? ProvServiceBrand.fromJson(
          json['provServiceBrand']
          as Map<String, dynamic>)
          : ProvServiceBrand.fromJson({}),

      models:
      (json['models'] as List<dynamic>?)
          ?.map((e) => ModelItem.fromJson(
          e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class ProvServiceBrand {
  final int id;
  final int provserviceid;
  final int brandid;
  final double? unifiedprice;
  final bool isunifiedprice;
  final double? cost;

  ProvServiceBrand({
    required this.id,
    required this.provserviceid,
    required this.brandid,
    required this.unifiedprice,
    required this.isunifiedprice,
    required this.cost,
  });

  factory ProvServiceBrand.fromJson(
      Map<String, dynamic> json) {

    return ProvServiceBrand(

      id:
      json['id'] ?? 0,

      provserviceid:
      json['provserviceid'] ?? 0,

      brandid:
      json['brandid'] ?? 0,

      unifiedprice:
      (json['unifiedprice'] as num?)
          ?.toDouble(),

      isunifiedprice:
      json['isunifiedprice'] ?? false,

      cost:
      (json['cost'] as num?)
          ?.toDouble(),
    );
  }
}

class ModelItem {

  final int id;
  final int provserviceid;
  final int carbrandid;
  final int carmodelid;

  final double price;
  final double cost;

  ModelItem({
    required this.id,
    required this.provserviceid,
    required this.carbrandid,
    required this.carmodelid,
    required this.price,
    required this.cost,
  });

  factory ModelItem.fromJson(
      Map<String, dynamic> json) {

    return ModelItem(

      id:
      json['id'] ?? 0,

      provserviceid:
      json['provserviceid'] ?? 0,

      carbrandid:
      json['carbrandid'] ?? 0,

      carmodelid:
      json['carmodelid'] ?? 0,

      price:
      (json['price'] as num?)
          ?.toDouble() ??
          0.0,

      cost:
      (json['cost'] as num?)
          ?.toDouble() ??
          0.0,
    );
  }
}