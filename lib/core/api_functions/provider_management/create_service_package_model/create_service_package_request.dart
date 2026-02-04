class CreateServicePackageRequest {
  final int provServiceId;
  final int packageName;
  final int packageLatinName;
  final int price;

  CreateServicePackageRequest({
    required this.provServiceId,
    required this.packageName,
    required this.packageLatinName,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "PROVSERVICEID": provServiceId,
      "PACKAGENAME": packageName,
      "PACKAGELATINNAME": packageLatinName,
      "PRICE": price,
    };
  }
}