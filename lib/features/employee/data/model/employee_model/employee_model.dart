class EmployeeModel {
  final int userId;
  final String userName;
  final String phone;
  final String email;
  final int type;
  final int gender;
  final String nationality;
  final bool isActive;
  final String fcmToken;
  final int providerId;
  final String jobName;
  final String jobLatinName;
  final int age;

  EmployeeModel({
    required this.userId,
    required this.userName,
    required this.phone,
    required this.email,
    required this.type,
    required this.gender,
    required this.nationality,
    required this.isActive,
    required this.fcmToken,
    required this.providerId,
    required this.jobName,
    required this.jobLatinName,
    required this.age
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      userId: int.tryParse('${json['userid']}') ?? 0,
      userName: json['username']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      type: int.tryParse('${json['type']}') ?? 0,
      gender: int.tryParse('${json['gender']}') ?? 0,
      nationality: json['nationality']?.toString() ?? '',
      isActive: json['isactive'] == true,
      fcmToken: json['fcmtoken']?.toString() ?? '',
      providerId: int.tryParse('${json['provid']}') ?? 0,
      jobName: json['jobname']?.toString() ?? '',
      jobLatinName: json['joblatinname']?.toString() ?? '',
      age: int.tryParse('${json['age']}') ?? 0,
    );
  }
}