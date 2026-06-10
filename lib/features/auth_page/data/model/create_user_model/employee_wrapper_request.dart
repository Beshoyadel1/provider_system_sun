import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';

class EmployeeWrapperRequest {
  final EmployeeModel? employeeDetails;
  final List<int> serviceIds;

  const EmployeeWrapperRequest({
    this.employeeDetails,
    this.serviceIds = const [],
  });

  factory EmployeeWrapperRequest.fromJson(
      dynamic json,
      ) {
    if (json == null) {
      return const EmployeeWrapperRequest();
    }

    if (json is! Map<String, dynamic>) {
      return const EmployeeWrapperRequest();
    }

    EmployeeModel? employee;

    if (json["employeeDetails"] != null &&
        json["employeeDetails"] is Map<String, dynamic>) {
      employee = EmployeeModel.fromJson(
        Map<String, dynamic>.from(
          json["employeeDetails"],
        ),
      );
    }

    List<int> services = [];

    if (json["serviceIds"] is List) {
      services = (json["serviceIds"] as List)
          .map(
            (e) => e is int
            ? e
            : int.tryParse(
          e.toString(),
        ) ??
            0,
      )
          .toList();
    }

    return EmployeeWrapperRequest(
      employeeDetails: employee,
      serviceIds: services,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employeeDetails": employeeDetails?.toJson(),
      "serviceIds": serviceIds,
    };
  }

  @override
  String toString() {
    return '''
EmployeeWrapperRequest(
employeeDetails: $employeeDetails,
serviceIds: $serviceIds
)
''';
  }
}