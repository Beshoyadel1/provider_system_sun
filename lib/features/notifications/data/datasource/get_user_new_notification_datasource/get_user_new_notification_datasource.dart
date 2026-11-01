import 'package:dio/dio.dart';
import 'package:sun_web_system/core/api/api_json.dart';
import '../get_user_notification_datasource/get_user_notification_datasource.dart';
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

    final raw = ApiJson.decode(response.data);
    if ((response.statusCode ?? 500) >= 400 ||
        (raw is Map && (raw['success'] == false || raw['status'] == false))) {
      throw Exception('Failed to load unread notifications');
    }
    final result = GetUserNewNotificationResponse.fromJson(raw);
    if (result.isComplete) return result.data;

    // Some backend versions return only the latest notification. Load the
    // existing history endpoint once, page by page, to obtain a real unread set.
    final byId = {for (final item in result.data) item.id!: item};
    var lastPage = 1;
    for (var page = 1; page <= lastPage; page++) {
      final history = await getUserNotificationFunction(
        request: GetUserNewNotificationRequest(
          userId: request.userId,
          userType: request.userType,
          pageNumber: page,
          pageSize: 20,
        ),
      );
      if (page == 1) lastPage = history.pageCount;
      if (lastPage > 1 && history.currentPage != page) {
        throw const FormatException('Invalid notification history page');
      }
      for (final item in history.data) {
        if (item.isViewed == null) {
          throw const FormatException('Notification read status is missing');
        }
        byId[item.id!] = item;
      }
    }
    return byId.values.where((item) => item.isViewed != true).toList();
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
