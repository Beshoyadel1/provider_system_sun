import 'package:equatable/equatable.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/order_model.dart';

abstract class GetProviderInternalOrderState extends Equatable {
  const GetProviderInternalOrderState();

  @override
  List<Object?> get props => [];
}

class GetProviderInternalOrderInitial
    extends GetProviderInternalOrderState {}

class GetProviderInternalOrderLoading
    extends GetProviderInternalOrderState {}

class GetProviderInternalOrderSuccess
    extends GetProviderInternalOrderState {
  final List<OrderModel> orders;

  const GetProviderInternalOrderSuccess(this.orders);

  @override
  List<Object?> get props => [orders];
}

class GetProviderInternalOrderError
    extends GetProviderInternalOrderState {
  final String message;

  const GetProviderInternalOrderError(this.message);

  @override
  List<Object?> get props => [message];
}