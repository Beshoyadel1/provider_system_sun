import 'package:dio/dio.dart';
import 'package:sun_web_system/core/api/api_json.dart';
import '../../../../../features/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import '../../../../../features/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<GetUserNotificationResponse> getUserNotificationFunction({
  required GetUserNewNotificationRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getUserNotification,
    );

    final raw = ApiJson.decode(response.data);
    if ((response.statusCode ?? 500) >= 400 ||
        (raw is Map && (raw['success'] == false || raw['status'] == false))) {
      throw Exception('Failed to load notifications');
    }
    if (raw is List) {
      return GetUserNotificationResponse.fromJson({'data': raw});
    }
    if (raw is! Map) {
      throw const FormatException('Invalid notification history response');
    }
    return GetUserNotificationResponse.fromJson(ApiJson.object(raw));
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
