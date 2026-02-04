class CreateProvServiceRequest {
  final int provId;
  final int serviceId;
  final int price;

  CreateProvServiceRequest({
    required this.provId,
    required this.serviceId,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "PROVID": provId,
      "SERVICEID": serviceId,
      "PRICE": price,
    };
  }
}
