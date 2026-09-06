class CreateProvServiceResponse {
  final int id;
  final int serviceId;
  final int providerId;
  final int taxId;
  final String name;
  final String latinName;
  final double unifiedPrice;
  final bool isUnifiedPrice;
  final double cost;

  const CreateProvServiceResponse({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.taxId,
    required this.name,
    required this.latinName,
    required this.unifiedPrice,
    required this.isUnifiedPrice,
    required this.cost,
  });

  factory CreateProvServiceResponse.fromJson(Map<String, dynamic> json) {
    return CreateProvServiceResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      serviceId: (json['serviceid'] as num?)?.toInt() ?? 0,
      providerId: (json['provid'] as num?)?.toInt() ?? 0,
      taxId: (json['taxid'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      latinName: json['latinname']?.toString() ?? '',
      unifiedPrice: (json['unifiedprice'] as num?)?.toDouble() ?? 0,
      isUnifiedPrice: json['isunifiedprice'] as bool? ?? false,
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
    );
  }
}
