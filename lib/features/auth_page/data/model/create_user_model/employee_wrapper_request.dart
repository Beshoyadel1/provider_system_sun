import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';


class EmployeeWrapperRequest {
  final EmployeeModel? employeeDetails;
  final List<int> serviceIds;
  final EmployeePermissionsModel? permissions;

  const EmployeeWrapperRequest({
    this.employeeDetails,
    this.serviceIds = const [],
    this.permissions,
  });

  factory EmployeeWrapperRequest.fromJson(
      dynamic json,
      ) {
    if (json == null || json is! Map) {
      return const EmployeeWrapperRequest();
    }

    // ================= EMPLOYEE =================

    EmployeeModel? employee;

    final employeeJson = json["employeeDetails"];

    if (employeeJson is Map) {
      employee = EmployeeModel.fromJson(
        Map<String, dynamic>.from(
          employeeJson,
        ),
      );
    }

    // ================= SERVICES =================

    final List<int> services = [];

    final servicesJson = json["serviceIds"];

    if (servicesJson is List) {
      for (final item in servicesJson) {
        final value = item is int
            ? item
            : int.tryParse(
          item.toString(),
        );

        if (value != null) {
          services.add(value);
        }
      }
    }

    // ================= PERMISSIONS =================

    EmployeePermissionsModel? permissions;

    final permissionsJson = json["permissions"];

    if (permissionsJson is Map) {
      permissions =
          EmployeePermissionsModel.fromJson(
            Map<String, dynamic>.from(
              permissionsJson,
            ),
          );
    }

    return EmployeeWrapperRequest(
      employeeDetails: employee,
      serviceIds: services,
      permissions: permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (employeeDetails != null)
        "employeeDetails":
        employeeDetails!.toJson(),

      "serviceIds": serviceIds,

      if (permissions != null)
        "permissions":
        permissions!.toJson(),
    };
  }

  @override
  String toString() {
    return '''
EmployeeWrapperRequest(
  employeeDetails: $employeeDetails,
  serviceIds: $serviceIds,
  permissions: $permissions
)
''';
  }
}

class EmployeePermissionsModel {
  final int? employeeid;
  final bool? acceptallorders;
  final bool? changeorderstatus;
  final bool? displayharage;

  const EmployeePermissionsModel({
    this.employeeid,
    this.acceptallorders,
    this.changeorderstatus,
    this.displayharage,
  });

  // =========================================================
  // PARSERS
  // =========================================================

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;

    if (value is bool) {
      return value;
    }

    if (value is int) {
      if (value == 1) return true;
      if (value == 0) return false;
    }

    if (value is String) {
      final normalized =
      value.trim().toLowerCase();

      if (normalized == 'true' ||
          normalized == '1') {
        return true;
      }

      if (normalized == 'false' ||
          normalized == '0') {
        return false;
      }
    }

    return null;
  }

  // =========================================================
  // FROM JSON
  // =========================================================

  factory EmployeePermissionsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeePermissionsModel(
      employeeid:
      _toInt(json["employeeid"]),

      acceptallorders:
      _toBool(
        json["acceptallorders"],
      ),

      changeorderstatus:
      _toBool(
        json["changeorderstatus"],
      ),

      displayharage:
      _toBool(
        json["displayharage"],
      ),
    );
  }

  // =========================================================
  // TO JSON
  // =========================================================

  Map<String, dynamic> toJson() {
    return {
      if (employeeid != null)
        "employeeid": employeeid,

      if (acceptallorders != null)
        "acceptallorders":
        acceptallorders,

      if (changeorderstatus != null)
        "changeorderstatus":
        changeorderstatus,

      if (displayharage != null)
        "displayharage":
        displayharage,
    };
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  EmployeePermissionsModel copyWith({
    int? employeeid,
    bool? acceptallorders,
    bool? changeorderstatus,
    bool? displayharage,
  }) {
    return EmployeePermissionsModel(
      employeeid:
      employeeid ?? this.employeeid,

      acceptallorders:
      acceptallorders ??
          this.acceptallorders,

      changeorderstatus:
      changeorderstatus ??
          this.changeorderstatus,

      displayharage:
      displayharage ??
          this.displayharage,
    );
  }

  // =========================================================
  // TO STRING
  // =========================================================

  @override
  String toString() {
    return '''
EmployeePermissionsModel(
  employeeid: $employeeid,
  acceptallorders: $acceptallorders,
  changeorderstatus: $changeorderstatus,
  displayharage: $displayharage
)
''';
  }
}