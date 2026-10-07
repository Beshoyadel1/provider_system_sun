import 'package:dio/dio.dart';
import '../../../../../features/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> makeNotificationViewedFunction({
  required GetUserNewNotificationRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.makeNotificationViewed,
    );
    if ((response.statusCode ?? 500) >= 400 ||
        (response.data is Map && (response.data['success'] == false || response.data['status'] == false))) {
      throw Exception('Failed to mark notifications as read');
    }
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
