import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';

class ProviderBranchModel {
  final int? branchId;
  final String? branchName;
  final String? branchLatinName;
  final String? address;
  final String? addressText;
  final String? addressLatinText;
  final String? nationalAddress;
  final double? lat;
  final double? long;
  final int? providerId;
  final bool? isActive;

  ProviderBranchModel({
    this.branchId,
    this.branchName,
    this.branchLatinName,
    this.address,
    this.addressText,
    this.addressLatinText,
    this.nationalAddress,
    this.lat,
    this.long,
    this.providerId,
    this.isActive = true,
  });

  factory ProviderBranchModel.fromJson(Map<String, dynamic> json) {
    return ProviderBranchModel(
      branchId: json['branchid'],
      branchName: json['branchname'] ?? '',
      branchLatinName: json['branchlatinname'] ?? '',
      address: json['address'] ?? '',
      addressText: json['addresstext'] ?? '',
      addressLatinText: json['addresslatintext'] ?? '',
      nationalAddress: json['nationaladdress'] ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      providerId: json['provid'],
      isActive: json['isactive'] ?? false,
    );
  }

  static List<ProviderBranchModel> fromList(List list) {
    return list.map((e) => ProviderBranchModel.fromJson(e)).toList();
  }

  String getBranchName(BuildContext context) {
    return LanguageCubit.localizedValue(context, branchName, branchLatinName);
  }

  String getAddressText(BuildContext context) {
    return LanguageCubit.localizedValue(context, addressText, addressLatinText);
  }
}
