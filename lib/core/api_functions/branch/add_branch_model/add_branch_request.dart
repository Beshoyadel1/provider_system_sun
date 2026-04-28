import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';

class AddBranchRequest {
  final int? branchId;
  final String branchName;
  final String branchLatinName;
  final String address;
  final String addressText;
  final String addressLatinText;
  final bool isActive;

  AddBranchRequest({
    this.branchId,
    required this.branchName,
    required this.branchLatinName,
    required this.address,
    required this.addressText,
    required this.addressLatinText,
    this.isActive = true,
  });

  Map<String, dynamic> toJson(int providerId) {
    return {
      if (branchId != null) "branchid": branchId,
      "branchname": branchName,
      "branchlatinname": branchLatinName,
      "address": address,
      "addresstext": addressText,
      "addresslatintext": addressLatinText,
      "provid": providerId,
      "isactive": isActive,
    };
  }

  String getBranchName(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? branchName : branchLatinName;
  }

  String getAddressText(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? addressText : addressLatinText;
  }
}