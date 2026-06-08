import 'dart:convert';
import 'dart:typed_data';

class ProviderDetailsRequest {
  final int? id;
  final String? name;
  final String? latinname;
  final String? description;
  final String? latindesc;
  final int? provid;
  final String? cr;
  final String? vatno;
  final int? packageid;
  final DateTime? subscriptionstartdate;
  final DateTime? subscriptionenddate;
  final String? iban;
  final String? nationaladdress;

  final Uint8List? crimage;
  final Uint8List? vatnoimage;
  final Uint8List? ibanimage;

  const ProviderDetailsRequest({
    this.id,
    this.name,
    this.latinname,
    this.description,
    this.latindesc,
    this.provid,
    this.cr,
    this.vatno,
    this.packageid,
    this.subscriptionstartdate,
    this.subscriptionenddate,
    this.iban,
    this.nationaladdress,
    this.crimage,
    this.vatnoimage,
    this.ibanimage,
  });

  factory ProviderDetailsRequest.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProviderDetailsRequest(
      id: json["id"],

      name: json["name"],

      latinname: json["latinname"],

      description: json["description"],

      latindesc: json["latindesc"],

      provid: json["provid"],

      cr: json["cr"],

      vatno: json["vatno"],

      packageid: json["packageid"],

      iban: json["iban"],

      nationaladdress: json["nationaladdress"],

      subscriptionstartdate:
      json["subscriptionstartdate"] != null
          ? DateTime.tryParse(
        json["subscriptionstartdate"],
      )
          : null,

      subscriptionenddate:
      json["subscriptionenddate"] != null
          ? DateTime.tryParse(
        json["subscriptionenddate"],
      )
          : null,

      crimage: _decodeImage(
        json["crimage"],
      ),

      vatnoimage: _decodeImage(
        json["vatnoimage"],
      ),

      ibanimage: _decodeImage(
        json["ibanimage"],
      ),
    );
  }

  static Uint8List? _decodeImage(
      dynamic value,
      ) {
    if (value == null) return null;

    if (value is! String) return null;

    if (value.trim().isEmpty) return null;

    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }

  static String? _encodeImage(
      Uint8List? image,
      ) {
    if (image == null || image.isEmpty) {
      return null;
    }

    return base64Encode(image);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    void addIfNotNull(
        String key,
        dynamic value,
        ) {
      if (value == null) return;

      if (value is String &&
          value.trim().isEmpty) {
        return;
      }

      data[key] = value;
    }

    addIfNotNull("id", id);

    addIfNotNull("name", name);

    addIfNotNull(
      "latinname",
      latinname,
    );

    addIfNotNull(
      "description",
      description,
    );

    addIfNotNull(
      "latindesc",
      latindesc,
    );

    addIfNotNull(
      "provid",
      provid,
    );

    addIfNotNull("cr", cr);

    addIfNotNull(
      "vatno",
      vatno,
    );

    addIfNotNull(
      "packageid",
      packageid,
    );

    addIfNotNull("iban", iban);

    addIfNotNull(
      "nationaladdress",
      nationaladdress,
    );

    addIfNotNull(
      "subscriptionstartdate",
      subscriptionstartdate
          ?.toIso8601String(),
    );

    addIfNotNull(
      "subscriptionenddate",
      subscriptionenddate
          ?.toIso8601String(),
    );

    final crImageEncoded =
    _encodeImage(crimage);

    final vatImageEncoded =
    _encodeImage(vatnoimage);

    final ibanImageEncoded =
    _encodeImage(ibanimage);

    addIfNotNull(
      "crimage",
      crImageEncoded,
    );

    addIfNotNull(
      "vatnoimage",
      vatImageEncoded,
    );

    addIfNotNull(
      "ibanimage",
      ibanImageEncoded,
    );

    return data;
  }

  ProviderDetailsRequest copyWith({
    int? id,
    String? name,
    String? latinname,
    String? description,
    String? latindesc,
    int? provid,
    String? cr,
    String? vatno,
    int? packageid,
    DateTime? subscriptionstartdate,
    DateTime? subscriptionenddate,
    String? iban,
    String? nationaladdress,
    Uint8List? crimage,
    Uint8List? vatnoimage,
    Uint8List? ibanimage,
  }) {
    return ProviderDetailsRequest(
      id: id ?? this.id,

      name: name ?? this.name,

      latinname:
      latinname ?? this.latinname,

      description:
      description ??
          this.description,

      latindesc:
      latindesc ?? this.latindesc,

      provid: provid ?? this.provid,

      cr: cr ?? this.cr,

      vatno: vatno ?? this.vatno,

      packageid:
      packageid ?? this.packageid,

      subscriptionstartdate:
      subscriptionstartdate ??
          this.subscriptionstartdate,

      subscriptionenddate:
      subscriptionenddate ??
          this.subscriptionenddate,

      iban: iban ?? this.iban,

      nationaladdress:
      nationaladdress ??
          this.nationaladdress,

      crimage:
      crimage ?? this.crimage,

      vatnoimage:
      vatnoimage ??
          this.vatnoimage,

      ibanimage:
      ibanimage ??
          this.ibanimage,
    );
  }
}