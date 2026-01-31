import 'dart:convert';
import 'dart:typed_data';

class CreateUserRequest {
  final String? username;
  final String? phone;
  final String? email;
  final String? password;
  final int? type;
  final String? referralCode;
  final bool? isActive;
  final Uint8List? image;
  final String? fcmToken;
  // final String? adminDetails;
  // final String? providerDetails;
  // final String? employeeDetails;
  // final String? companyDetails;
  // final String? driverDetails;
  // final String? appUserCars;
  final int? userid;
  final int? gander;
  final int? age;
  final String? nationality;
  final DateTime? joinDate;
  final int? currentCarId;

  const CreateUserRequest({
    this.username,
    this.phone,
    this.email,
    this.password,
    this.type,
    this.referralCode,
    this.isActive,
    this.image,
    this.fcmToken,
    // this.providerDetails,
    // this.employeeDetails,
    // this.driverDetails,
    // this.companyDetails,
    // this.appUserCars,
    // this.adminDetails,
    this.userid,
    this.age,
    this.currentCarId,
    this.joinDate,
    this.nationality,
    this.gander
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) {
    return CreateUserRequest(
      username: json["username"],
      phone: json["phone"],
      email: json["email"],
      password: json["password"],
      type: json["type"],
      referralCode: json["referralcode"],
      isActive: json["isactive"],
      fcmToken: json["fcmtoken"],
      // adminDetails: json["adminDetails"],
      // providerDetails: json["providerDetails"],
      // employeeDetails: json["employeeDetails"],
      // companyDetails: json["companyDetails"],
      // driverDetails: json["driverDetails"],
      // appUserCars: json["appUserCars"],
      userid: json["userid"],
      gander: json["gander"],
      age: json["age"],
      nationality: json["nationality"],
      joinDate: json["joindate"],
      currentCarId:json["currentcarid"],
      image: json["image"] != null ? base64Decode(json["image"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username ?? "",
      "phone": phone ?? "",
      "email": email ?? "",
      "password": password ?? "",
      "type": type ?? 0,
      "referralcode": referralCode ?? "",
      "isactive": isActive ?? false,
      "fcmtoken": fcmToken ?? "",
      // "adminDetails": adminDetails ?? "",
      // "providerDetails": providerDetails ?? "",
      // "employeeDetails": employeeDetails ?? "",
      // "companyDetails": companyDetails ?? "",
      // "driverDetails": driverDetails ?? "",
      // "appUserCars": appUserCars ?? "",
      "userid": userid ?? 0,
      "gander": gander ?? 0,
      "age": age ?? 0,
      "nationality": nationality ?? "",
      "joindate": (joinDate ?? DateTime.now()).toIso8601String(),
      "currentcarid": currentCarId ?? 0,
      "image": image != null ? base64Encode(image!) : null,
    };
  }
}
