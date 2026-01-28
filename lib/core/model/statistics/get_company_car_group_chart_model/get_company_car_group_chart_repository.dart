import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_company_car_group_chart_model/get_company_car_group_chart_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCompanyCarGroupChartFunction({
  required GetCompanyCarGroupChartRequest getCompanyCarGroupChartRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCompanyCarGroupChartRequest.toJson(), // params
      ApiLink.getCompanyCarGroupChart,
    );
    AppSnackBar.showSuccess("Get Company Car Group Chart successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
