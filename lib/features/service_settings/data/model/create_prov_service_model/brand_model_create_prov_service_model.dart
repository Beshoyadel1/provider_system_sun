import 'car_model_create_prov_service_model.dart';

class BrandModelCreateProvServiceModel {
  final int? id;
  final double? unifiedprice;
  final bool? isunifiedprice;
  final double? cost;
  final List<CarModelCreateProvServiceModel> cars;

  BrandModelCreateProvServiceModel({
    this.id,
    this.unifiedprice,
    this.isunifiedprice,
    this.cost,
    this.cars = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "unifiedprice": unifiedprice,
      "isunifiedprice": isunifiedprice,
      "cost": cost,
      "cars": cars.map((car) => car.toJson()).toList(),
    };
  }
}
