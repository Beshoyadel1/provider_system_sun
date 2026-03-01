class ServiceModel {
  final int? id;
  final int? parentId;
  final String? name;
  final String? latinName;
  final String? image;

  ServiceModel({
     this.id,
     this.parentId,
     this.name,
     this.latinName,
     this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      parentId: json['parentid'] ?? 0,
      name: json['name'] ?? '',
      latinName: json['latinname'] ?? '',
      image: json['image'],
    );
  }
}