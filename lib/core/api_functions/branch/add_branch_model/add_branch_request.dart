import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';

class AddBranchRequest {
  final int? branchId;
  final String? branchName;
  final String? branchLatinName;
  final String? address;
  final String? addressText;
  final String? addressLatinText;
  final int? providerId;
  final bool? isActive;

  AddBranchRequest({
     this.branchId,
     this.branchName,
     this.branchLatinName,
     this.address,
     this.addressText,
     this.addressLatinText,
    this.providerId,
     this.isActive,
  });

  Map<String, dynamic> toJson(int providerIdFromCubit) {
    return {
      "branchid": branchId,
      "branchname": branchName,
      "branchlatinname": branchLatinName,
      "address": address,
      "addresstext": addressText,
      "addresslatintext": addressLatinText,
      "provid": providerId ?? providerIdFromCubit,
      "isactive": isActive,
    };
  }
  String getBranchName(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic
        ? (branchName ?? "")
        : (branchLatinName ?? "");
  }
  String getAddressText(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic
        ? (addressText ?? "")
        : (addressLatinText ?? "");
  }
}