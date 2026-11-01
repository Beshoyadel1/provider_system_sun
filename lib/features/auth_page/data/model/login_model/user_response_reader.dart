import '../../../../../core/api/api_json.dart';
import '../../../../../core/language/language_constant.dart';
import '../create_user_model/create_user_request.dart';

/// Reads a single account; the documentation's generic {id: 1} is not a profile.
class UserResponseReader {
  static CreateUserRequest read(Object? data,
      {required int expectedType, int? expectedUserId}) {
    if (data is List) {
      if (data.length != 1) {
        throw const FormatException(AppLanguageKeys.invalidUserInformation);
      }
      data = data.single;
    }
    if (data is! Map) {
      throw const FormatException(AppLanguageKeys.invalidUserInformation);
    }
    final json = ApiJson.object(data);
    final id = int.tryParse('${json['userId']}');
    final type = int.tryParse('${json['type']}');
    if (id == null ||
        id <= 0 ||
        type != expectedType ||
        (expectedUserId != null && id != expectedUserId)) {
      throw const FormatException(AppLanguageKeys.invalidUserInformation);
    }
    return CreateUserRequest.fromJson({...json, 'userId': id, 'type': type});
  }
}
