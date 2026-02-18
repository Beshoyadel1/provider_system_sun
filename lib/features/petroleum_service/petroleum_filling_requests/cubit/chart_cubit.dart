import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api_functions/statistics/get_provider_petrol_sales_chart_model/get_provider_petrol_sales_chart_repository.dart';
import '../../../../features/petroleum_service/petroleum_filling_requests/cubit/chart_state.dart';
import '../../../../core/api_functions/statistics/get_provider_petrol_sales_chart_model/get_provider_petrol_sales_chart_request.dart';


class PetrolChartCubit extends Cubit<PetrolChartState> {
  PetrolChartCubit() : super(PetrolChartInitial());

  Future<void> getPetrolChart(
      GetProviderPetrolSalesChartRequest request) async {

    emit(PetrolChartLoading());

    try {
      final result =
      await getProviderPetrolSalesChartFunction(
          getProviderPetrolSalesChartRequest: request);

      if (result != null) {
        emit(PetrolChartSuccess(result.dataPoints));
      } else {
        //emit(PetrolChartError("No Data Returned"));
      }
    } catch (e) {
      emit(PetrolChartError(e.toString()));
    }
  }
}
