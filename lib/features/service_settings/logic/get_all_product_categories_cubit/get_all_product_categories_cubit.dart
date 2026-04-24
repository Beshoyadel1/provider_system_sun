import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/product/get_all_product_categories_model/product_category_model.dart';
import '../../../../core/api_functions/product/get_all_product_categories_model/get_all_product_categories_repository.dart';
import '../../../../features/service_settings/logic/get_all_product_categories_cubit/get_all_product_categories_state.dart';

class GetAllProductCategoriesCubit
    extends Cubit<GetAllProductCategoriesState> {
  GetAllProductCategoriesCubit()
      : super(GetAllProductCategoriesInitial());

  List<ProductCategoryModel> categories = [];
  ProductCategoryModel? selectedCategory;

  Future<void> getAllProductCategories() async {
    emit(GetAllProductCategoriesLoading());

    try {
      final result = await getAllProductCategoriesFunction();

      categories = result;

      emit(GetAllProductCategoriesSuccess(result));
    } catch (e) {
      emit(GetAllProductCategoriesError(e.toString()));
    }
  }

  void selectCategory(ProductCategoryModel category) {
    selectedCategory = category;
    emit(GetAllProductCategoriesSuccess(categories));
  }
}