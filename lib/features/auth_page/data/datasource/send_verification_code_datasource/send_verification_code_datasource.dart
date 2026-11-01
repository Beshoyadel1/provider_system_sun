import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/api_json.dart';
import '../../request/send_verification_code_request/send_verification_code_request.dart';

Future<bool> sendVerificationCodeFunction({
  required SendVerificationCodeRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      null,
      request.toJson(),
      ApiLink.sendVerificationCode,
    );

    final data = response.data;

    if ((response.statusCode ?? 500) >= 400 || data is! Map) return false;
    final body = ApiJson.object(data);
    if (body['status'] == false) return false;
    if (body.containsKey('success')) {
      return body['success'] == true;
    }
    // Compatibility with the old SMS envelope, never overriding an explicit rejection.
    return int.tryParse('${body['statusCode']}') == 201;
  } catch (_) {
    return false;
  }
}
