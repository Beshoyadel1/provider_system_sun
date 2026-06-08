import 'dart:convert';
import 'dart:typed_data';

import 'package:sun_web_system/features/auth_page/data/model/create_user_model/employee_wrapper_request.dart';

import 'company_details_request.dart';
import 'driver_details_request.dart';
import 'employee_details_request.dart';
import 'provider_details_request.dart';
import 'admin_details_request.dart';

class CreateUserEmpRequest {
  final int? userid;
  final String? username;
  final String? phone;
  final String? email;
  final String? password;
  final int? gender;
  final int? age;
  final int? type;
  final String? nationality;
  final bool? isActive;
  final DateTime? joinDate;
  final String? referralCode;
  final Uint8List? image;
  final String? fcmToken;
  final int? defaultcarid;

  final AdminDetailsRequest? adminDetails;
  final ProviderDetailsRequest? providerDetails;
  final EmployeeWrapperRequest? employeeDetails;
  final CompanyDetailsRequest? companyDetails;
  final DriverDetailsRequest? driverDetails;

  const CreateUserEmpRequest({
    this.userid,
    this.username,
    this.phone,
    this.email,
    this.password,
    this.gender,
    this.age,
    this.type,
    this.nationality,
    this.isActive,
    this.joinDate,
    this.referralCode,
    this.image,
    this.fcmToken,
    this.defaultcarid,
    this.adminDetails,
    this.providerDetails,
    this.employeeDetails,
    this.companyDetails,
    this.driverDetails,
  });

  factory CreateUserEmpRequest.fromJson(
      Map<String, dynamic> json,
      ) {
    return CreateUserEmpRequest(
      userid: json["userid"],

      username: json["username"],

      phone: json["phone"],

      email: json["email"],

      password: json["password"],

      gender: json["gender"],

      age: json["age"],

      type: json["type"],

      nationality: json["nationality"],

      isActive: json["isactive"],

      referralCode: json["referralcode"],

      fcmToken: json["fcmtoken"],

      defaultcarid:
      json["defaultcarid"],

      joinDate:
      json["joindate"] != null
          ? DateTime.parse(
        json["joindate"],
      )
          : null,

      image: json["image"] != null
          ? base64Decode(
        json["image"],
      )
          : null,

      adminDetails:
      json["adminDetails"] != null
          ? AdminDetailsRequest
          .fromJson(
        json["adminDetails"],
      )
          : null,

      providerDetails:
      json["providerDetails"] != null
          ? ProviderDetailsRequest
          .fromJson(
        json["providerDetails"],
      )
          : null,

      employeeDetails:
      json["employeeDetails"] != null
          ? EmployeeWrapperRequest
          .fromJson(
        json["employeeDetails"],
      )
          : null,

      companyDetails:
      json["companyDetails"] != null
          ? CompanyDetailsRequest
          .fromJson(
        json["companyDetails"],
      )
          : null,

      driverDetails:
      json["driverDetails"] != null
          ? DriverDetailsRequest
          .fromJson(
        json["driverDetails"],
      )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (userid != null) {
      data["userid"] = userid;
    }

    if (username != null &&
        username!.isNotEmpty) {
      data["username"] = username;
    }

    if (phone != null &&
        phone!.isNotEmpty) {
      data["phone"] = phone;
    }

    if (email != null &&
        email!.isNotEmpty) {
      data["email"] = email;
    }

    if (password != null &&
        password!.isNotEmpty) {
      data["password"] = password;
    }

    if (gender != null) {
      data["gender"] = gender;
    }

    if (age != null) {
      data["age"] = age;
    }

    if (type != null) {
      data["type"] = type;
    }

    if (nationality != null &&
        nationality!.isNotEmpty) {
      data["nationality"] = nationality;
    }

    if (isActive != null) {
      data["isactive"] = isActive;
    }

    if (joinDate != null) {
      data["joindate"] =
          joinDate!.toIso8601String();
    }

    if (referralCode != null &&
        referralCode!.isNotEmpty) {
      data["referralcode"] =
          referralCode;
    }

    if (fcmToken != null &&
        fcmToken!.isNotEmpty) {
      data["fcmtoken"] = fcmToken;
    }

    if (defaultcarid != null) {
      data["defaultcarid"] =
          defaultcarid;
    }

    if (image != null) {
      data["image"] =
          base64Encode(image!);
    }

    if (adminDetails != null) {
      data["adminDetails"] =
          adminDetails!.toJson();
    }

    if (providerDetails != null) {
      data["providerDetails"] =
          providerDetails!.toJson();
    }

    if (employeeDetails != null) {
      data["employeeDetails"] =
          employeeDetails!.toJson();
    }

    if (companyDetails != null) {
      data["companyDetails"] =
          companyDetails!.toJson();
    }

    if (driverDetails != null) {
      data["driverDetails"] =
          driverDetails!.toJson();
    }

    return data;
  }
}
