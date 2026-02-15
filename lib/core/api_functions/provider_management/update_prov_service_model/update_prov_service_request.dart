class UpdateProvServiceRequest {
  final int id;
  final int price;

  UpdateProvServiceRequest({
    required this.id,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "PRICE": price,
    };
  }
}
