import 'package:flutter_bloc/flutter_bloc.dart';

class ServicePermissionCubit extends Cubit<List<int>> {
  ServicePermissionCubit() : super([]);

  void toggle(int serviceId) {
    final selected = List<int>.from(state);

    if (selected.contains(serviceId)) {
      selected.remove(serviceId);
    } else {
      selected.add(serviceId);
    }

    emit(selected);
  }

  bool isSelected(int serviceId) {
    return state.contains(serviceId);
  }

  void setSelected(List<int> ids) {
    emit(ids);
  }

  void clear() {
    emit([]);
  }
}