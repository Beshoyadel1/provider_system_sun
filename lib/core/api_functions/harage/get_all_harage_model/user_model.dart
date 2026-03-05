class UserModel {
  final int? id;
  final int? type;
  final String? name;
  final String? latinName;
  final String? image;
  final String? branchName;
  final String? branchLatinName;

  UserModel({
     this.id,
     this.type,
     this.name,
     this.latinName,
    this.image,
    this.branchName,
    this.branchLatinName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      latinName: json['latinname'],
      image: json['image'],
      branchName: json['branchname'],
      branchLatinName: json['branchlatinname'],
    );
  }
}