import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api_functions/harage/get_all_harage_model/get_all_harage_repository.dart';
import '../../../../core/api_functions/harage/get_all_harage_model/get_all_harage_request.dart';
import 'get_all_harage_state.dart';

class GetAllHarageCubit extends Cubit<GetAllHarageState> {
  GetAllHarageCubit() : super(GetAllHarageInitial());

  Future<void> getAllHarage({int page = 1}) async {
    try {
      emit(GetAllHarageLoading());

      final request = GetAllHarageRequest(pageNumber: page);

      final result = await getAllHarageFunction(
        getAllHarageRequest: request,
      );

      emit(GetAllHarageSuccess(result));
    } catch (e) {
      emit(GetAllHarageError(e.toString()));
    }
  }
}