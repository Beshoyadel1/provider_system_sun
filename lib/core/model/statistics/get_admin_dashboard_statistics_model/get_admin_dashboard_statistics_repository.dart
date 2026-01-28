import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> getAdminDashboardStatisticsFunction({
  required GetAdminDashboardStatisticsRequest getAdminDashboardStatisticsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getAdminDashboardStatisticsRequest.toJson(), // params
        ApiLink.getAdminDashboardStatistics
    );
    AppSnackBar.showSuccess("Get Admin Dashboard Statistics successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}