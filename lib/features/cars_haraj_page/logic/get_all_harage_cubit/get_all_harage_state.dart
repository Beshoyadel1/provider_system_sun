import '../../../../core/api_functions/harage/get_all_harage_model/get_all_harage_response.dart';

abstract class GetAllHarageState {}

class GetAllHarageInitial extends GetAllHarageState {}

class GetAllHarageLoading extends GetAllHarageState {}

class GetAllHarageSuccess extends GetAllHarageState {
  final GetAllHarageResponse response;
  final int currentPage;

  GetAllHarageSuccess({
    required this.response,
    this.currentPage = 1,
  });
}

class GetAllHarageError extends GetAllHarageState {
  final String message;

  GetAllHarageError(this.message);
}