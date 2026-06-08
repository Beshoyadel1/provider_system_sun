class BrandModelCreateProvServiceModel {
  final int? id;
  final double? unifiedprice;
  final bool? isunifiedprice;
  final double? cost;

  BrandModelCreateProvServiceModel({
     this.id,
     this.unifiedprice,
     this.isunifiedprice,
     this.cost,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "unifiedprice": unifiedprice,
      "isunifiedprice": isunifiedprice,
      "cost": cost,
    };
  }
}