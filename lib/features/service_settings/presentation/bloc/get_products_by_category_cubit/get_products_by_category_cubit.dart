import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_products_by_category_datasource/get_products_by_category_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/get_products_by_category_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_products_by_category_cubit/get_products_by_category_state.dart';

class GetProductsByCategoryCubit
    extends Cubit<GetProductsByCategoryState> {
  GetProductsByCategoryCubit()
      : super(GetProductsByCategoryInitial());

  List<ProductModelGetProductsByCategory> products = [];

  Future<void> getProductsByCategory({
    required int categoryId,
  }) async {
    emit(GetProductsByCategoryLoading());

    final result = await getProductsByCategoryFunction(
      request: GetProductsByCategoryRequest(
        categoryId: categoryId,
      ),
    );

    products = result;

    emit(GetProductsByCategorySuccess());
  }
}