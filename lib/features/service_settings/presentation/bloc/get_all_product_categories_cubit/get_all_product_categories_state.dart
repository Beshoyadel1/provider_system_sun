import 'package:sun_web_system/features/service_settings/data/model/get_all_product_categories_model/product_category_model.dart';

abstract class GetAllProductCategoriesState {}

class GetAllProductCategoriesInitial extends GetAllProductCategoriesState {}

class GetAllProductCategoriesLoading extends GetAllProductCategoriesState {}

class GetAllProductCategoriesSuccess extends GetAllProductCategoriesState {
  final List<ProductCategoryModel> categories;

  GetAllProductCategoriesSuccess(this.categories);
}

class GetAllProductCategoriesError extends GetAllProductCategoriesState {
  final String error;

  GetAllProductCategoriesError(this.error);
}