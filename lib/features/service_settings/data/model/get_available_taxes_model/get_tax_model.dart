class GetTaxModel {
  final int taxId;
  final int taxPercentage;

  GetTaxModel({
    required this.taxId,
    required this.taxPercentage,
  });

  factory GetTaxModel.fromJson(
      Map<String, dynamic> json) {

    final data =
        json['data'] as Map<String, dynamic>? ?? json;

    return GetTaxModel(
      taxId:
      data['taxid'] ?? 0,

      taxPercentage:
      data['taxpercentage'] ?? 0,
    );
  }
}