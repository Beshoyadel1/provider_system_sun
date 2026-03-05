class CarModel {
  final int? id;
  final String? brandName;
  final String? brandLatinName;
  final String? brandImage;
  final String? modelName;
  final String? carImage;

  CarModel({
    this.id,
    this.brandName,
    this.brandLatinName,
    this.brandImage,
    this.modelName,
    this.carImage,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      brandName: json['brandname'],
      brandLatinName: json['brandlatinname'],
      brandImage: json['brandimage'],
      modelName: json['modelname'],
      carImage: json['carimage'],
    );
  }
}
