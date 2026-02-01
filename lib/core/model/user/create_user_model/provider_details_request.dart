class ProviderDetailsRequest {
  final int? id;
  final String? name;
  final String? latinname;
  final String? description;
  final String? latindesc;
  final int? provid;
  final String? cr;
  final String? vatno;

  const ProviderDetailsRequest({
    this.id,
    this.name,
    this.latinname,
    this.description,
    this.latindesc,
    this.provid,
    this.cr,
    this.vatno,
  });

  factory ProviderDetailsRequest.fromJson(Map<String, dynamic> json) =>
      ProviderDetailsRequest(
        id: json["id"],
        name: json["name"],
        latinname: json["latinname"],
        description: json["description"],
        latindesc: json["latindesc"],
        provid: json["provid"],
        cr: json["cr"],
        vatno: json["vatno"],
      );

  Map<String, dynamic> toJson() => {
    "id": id??0,
    "name": name??"",
    "latinname": latinname??"",
    "description": description??"",
    "latindesc": latindesc??"",
    "provid": provid??0,
    "cr": cr??"",
    "vatno": vatno??"",
  };
}
