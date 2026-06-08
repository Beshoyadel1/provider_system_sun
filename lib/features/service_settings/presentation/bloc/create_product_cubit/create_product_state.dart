
abstract class CreateProductState {}

class CreateProductInitial extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {}

class CreateProductError extends CreateProductState {
  final String error;
  CreateProductError(this.error);
}

class UpdateProductLoading extends CreateProductState {}
class UpdateProductSuccess extends CreateProductState {}