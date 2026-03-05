class GetAllHarageRequest {
  final int? pageNumber;

  GetAllHarageRequest({
     this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber??1,
    };
  }
}