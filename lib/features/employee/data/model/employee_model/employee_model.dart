import 'package:flutter/foundation.dart';

class EmployeeModel {
  final int? id;
  final int? provid;
  final String? jobname;
  final String? joblatinname;
  final int? branchid;

  const EmployeeModel({
    this.id,
    this.provid,
    this.jobname,
    this.joblatinname,
    this.branchid,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return int.tryParse(value.toString());
  }

  factory EmployeeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeeModel(
      id: _toInt(json["id"]),
      provid: _toInt(json["provid"]),
      branchid: _toInt(json["branchid"]),
      jobname: json["jobname"]?.toString(),
      joblatinname: json["joblatinname"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) {
      data["id"] = id;
    }

    if (provid != null) {
      data["provid"] = provid;
    }

    if (jobname != null && jobname!.isNotEmpty) {
      data["jobname"] = jobname;
    }

    if (joblatinname != null &&
        joblatinname!.isNotEmpty) {
      data["joblatinname"] = joblatinname;
    }

    if (branchid != null) {
      data["branchid"] = branchid;
    }

    return data;
  }

  @override
  String toString() {
    return '''
EmployeeModel(
id: $id,
provid: $provid,
jobname: $jobname,
joblatinname: $joblatinname,
branchid: $branchid
)
''';
  }
}