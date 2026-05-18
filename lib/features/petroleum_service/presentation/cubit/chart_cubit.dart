import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/petroleum_service/presentation/cubit/chart_state.dart';
import '../../data/datasource/get_provider_petrol_sales_chart_datasource/get_provider_petrol_sales_chart_repository.dart';
import '../../data/request/get_provider_petrol_sales_chart_request/get_provider_petrol_sales_chart_request.dart';

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
