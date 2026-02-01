import '../../../../core/language/language_constant.dart';

String responseOfStatusCode(int? statusCode) {
  if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
    return AppLanguageKeys.badResponseError;
  } else if (statusCode == 404) {
    return AppLanguageKeys.requestNotFound;
  } else if (statusCode == 500) {
    return AppLanguageKeys.internalServerError;
  } else {
    return AppLanguageKeys.oopsErrorTryAgain;
  }
}
