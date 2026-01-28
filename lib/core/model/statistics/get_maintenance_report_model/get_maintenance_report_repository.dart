import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_maintenance_report_model/get_maintenance_report_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> getMaintenanceReportFunction({
  required GetMaintenanceReportRequest getMaintenanceReportRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getMaintenanceReportRequest.toJson(), // params
      ApiLink.getMaintenanceReport,
    );
    AppSnackBar.showSuccess("Get Maintenance Report successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
