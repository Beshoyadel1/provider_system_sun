class UpdateServicePackageRequest {
  final int id;
  final int packageName;

  UpdateServicePackageRequest({
    required this.id,
    required this.packageName,
  });

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "PACKAGENAME": packageName,
    };
  }
}
