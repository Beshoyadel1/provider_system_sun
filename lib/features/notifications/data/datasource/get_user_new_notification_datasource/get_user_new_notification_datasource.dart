import 'package:dio/dio.dart';
import '../../../../../../features/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import '../../../../../../features/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<List<NotificationModel>> getUserNewNotificationFunction({
  required GetUserNewNotificationRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getUserNewNotification,
    );

    final raw = response.data;
    if ((response.statusCode ?? 500) >= 400 ||
        (raw is Map && (raw['success'] == false || raw['status'] == false))) {
      throw Exception('Failed to load unread notifications');
    }
    final list = raw is List ? raw : (raw is Map ? raw['data'] : null);
    return (list is List ? list : const [])
        .whereType<Map>()
        .map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
