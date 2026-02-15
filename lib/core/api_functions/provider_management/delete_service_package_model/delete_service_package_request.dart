class DeleteServicePackageRequest {
  final int packageId;

  DeleteServicePackageRequest({
    required this.packageId,
  });

  Map<String, dynamic> toJson() {
    return {
      "packageId": packageId,
    };
  }
}

