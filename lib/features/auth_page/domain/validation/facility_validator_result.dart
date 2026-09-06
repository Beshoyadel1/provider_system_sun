import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';

class FacilityValidatorResult {
  final bool isValid;
  final List<String> missingFields;

  FacilityValidatorResult({
    required this.isValid,
    required this.missingFields,
  });
}

class FacilityValidator {
  static FacilityValidatorResult validate({
    required CreateUserRequest user,
  }) {
    final p = user.providerDetails;

    List<String> missing = [];

    bool isValid(String? value) {
      return value != null && value.trim().isNotEmpty && value.trim() != "null";
    }

    /// 🔴 Basic data
    if (!isValid(p?.name)) missing.add(AppLanguageKeys.facilityName);
    if (!isValid(p?.latinname)) missing.add(AppLanguageKeys.facilityNameEn);
    // if (!isValid(p?.cr)) missing.add(AppLanguageKeys.commercialRecordKey);
    // if (!isValid(p?.vatno)) missing.add(AppLanguageKeys.taxNumber);
    if (!isValid(user.phone)) missing.add(AppLanguageKeys.phoneNumber);
    if (!isValid(user.email)) missing.add(AppLanguageKeys.email);

    /// 🔴 Images
    //  if (!isValid(p?.crimage?.toString())) missing.add(AppLanguageKeys.commercialRecordKey);
    // if (!isValid(p?.vatnoimage?.toString())) missing.add(AppLanguageKeys.taxNumber);
    //if (!isValid(user.image?.toString())) missing.add(AppLanguageKeys.ownerIdKey);

    return FacilityValidatorResult(
      isValid: missing.isEmpty,
      missingFields: missing,
    );
  }
}
