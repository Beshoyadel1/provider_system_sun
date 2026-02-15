abstract class NewOrdersState {}

class NewOrdersInitial extends NewOrdersState {}

class NewOrderDetails extends NewOrdersState {}

class ChangeIndexState extends NewOrdersState {}
