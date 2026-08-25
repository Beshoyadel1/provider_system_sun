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

  factory EmployeeWrapperRequest.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return const EmployeeWrapperRequest();
    }

    // =========================================================
    // EMPLOYEE DETAILS
    // =========================================================

    EmployeeModel? employee;

    final employeeJson = json["employeeDetails"];

    if (employeeJson is Map) {
      employee = EmployeeModel.fromJson(
        Map<String, dynamic>.from(employeeJson),
      );
    }

    // =========================================================
    // SERVICE IDS
    // =========================================================

    final List<int> services = [];

    final servicesJson = json["serviceIds"];

    if (servicesJson is List) {
      for (final item in servicesJson) {
        final value = item is int
            ? item
            : int.tryParse(item.toString());

        if (value != null) {
          services.add(value);
        }
      }
    }

    // =========================================================
    // PERMISSIONS
    // =========================================================

    EmployeePermissionsModel? permissions;

    final permissionsJson = json["permissions"];

    if (permissionsJson is Map) {
      permissions = EmployeePermissionsModel.fromJson(
        Map<String, dynamic>.from(permissionsJson),
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
        "employeeDetails": employeeDetails!.toJson(),

      "serviceIds": serviceIds,

      if (permissions != null)
        "permissions": permissions!.toJson(),
    };
  }

  EmployeeWrapperRequest copyWith({
    EmployeeModel? employeeDetails,
    List<int>? serviceIds,
    EmployeePermissionsModel? permissions,
  }) {
    return EmployeeWrapperRequest(
      employeeDetails:
      employeeDetails ?? this.employeeDetails,
      serviceIds:
      serviceIds ?? this.serviceIds,
      permissions:
      permissions ?? this.permissions,
    );
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

  final bool? harage;
  final bool? maintenanceandinternalservices;
  final bool? mobileservices;
  final bool? spareparts;
  final bool? servicepackage;
  final bool? petrol;

  const EmployeePermissionsModel({
    this.employeeid,
    this.acceptallorders,
    this.changeorderstatus,
    this.harage,
    this.maintenanceandinternalservices,
    this.mobileservices,
    this.spareparts,
    this.servicepackage,
    this.petrol,
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
      employeeid: _toInt(
        json["employeeid"],
      ),

      acceptallorders: _toBool(
        json["acceptallorders"],
      ),

      changeorderstatus: _toBool(
        json["changeorderstatus"],
      ),

      harage: _toBool(
        json["harage"],
      ),

      maintenanceandinternalservices: _toBool(
        json["maintenanceandinternalservices"],
      ),

      mobileservices: _toBool(
        json["mobileservices"],
      ),

      spareparts: _toBool(
        json["spareparts"],
      ),

      servicepackage: _toBool(
        json["servicepackage"],
      ),

      petrol: _toBool(
        json["petrol"],
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
        "acceptallorders": acceptallorders,

      if (changeorderstatus != null)
        "changeorderstatus": changeorderstatus,

      if (harage != null)
        "harage": harage,

      if (maintenanceandinternalservices != null)
        "maintenanceandinternalservices":
        maintenanceandinternalservices,

      if (mobileservices != null)
        "mobileservices": mobileservices,

      if (spareparts != null)
        "spareparts": spareparts,

      if (servicepackage != null)
        "servicepackage": servicepackage,

      if (petrol != null)
        "petrol": petrol,
    };
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  EmployeePermissionsModel copyWith({
    int? employeeid,
    bool? acceptallorders,
    bool? changeorderstatus,
    bool? harage,
    bool? maintenanceandinternalservices,
    bool? mobileservices,
    bool? spareparts,
    bool? servicepackage,
    bool? petrol,
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

      harage:
      harage ?? this.harage,

      maintenanceandinternalservices:
      maintenanceandinternalservices ??
          this.maintenanceandinternalservices,

      mobileservices:
      mobileservices ??
          this.mobileservices,

      spareparts:
      spareparts ??
          this.spareparts,

      servicepackage:
      servicepackage ??
          this.servicepackage,

      petrol:
      petrol ?? this.petrol,
    );
  }

  @override
  String toString() {
    return '''
EmployeePermissionsModel(
  employeeid: $employeeid,
  acceptallorders: $acceptallorders,
  changeorderstatus: $changeorderstatus,
  harage: $harage,
  maintenanceandinternalservices: $maintenanceandinternalservices,
  mobileservices: $mobileservices,
  spareparts: $spareparts,
  servicepackage: $servicepackage,
  petrol: $petrol
)
''';
  }
}