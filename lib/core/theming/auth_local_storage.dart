import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../../../features/auth_page/data/request/login_request/login_request.dart';
import '../../../../../../features/auth_page/data/model/create_user_model/create_user_request.dart';

class AuthLocalStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String userKey = "user_data";
  static const String passwordKey = "password";

  static Future<void> saveUser(CreateUserRequest user) async {
    await _storage.write(
      key: userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  static Future<CreateUserRequest?> getUser() async {
    final data = await _storage.read(key: userKey);

    if (data == null || data.isEmpty) return null;

    return CreateUserRequest.fromJson(jsonDecode(data));
  }

  static Future<bool> isLoggedIn() async {
    final data = await _storage.read(key: userKey);
    return data != null && data.isNotEmpty;
  }

  static Future<void> clearUser() async {
    await _storage.delete(key: userKey);
  }

  static Future<void> savePassword(String password) async {
    await _storage.write(
      key: passwordKey,
      value: password,
    );

    final savedPassword = await _storage.read(
      key: passwordKey,
    );

    print("Saved Password: $savedPassword");
  }

  static Future<String?> getPassword() async {
    return await _storage.read(
      key: passwordKey,
    );
  }

  static Future<void> printPassword() async {
    final password = await _storage.read(
      key: passwordKey,
    );

    print("Password: $password");
  }

  static Future<void> clearPassword() async {
    await _storage.delete(
      key: passwordKey,
    );
  }
  static Future<bool> refreshAndSaveUser() async {
    final localUser = await getUser();
    final password = await getPassword();

    if (localUser == null ||
        password == null ||
        localUser.email == null) {
      return false;
    }

    final result = await loginFunction(
      loginRequest: LoginRequest(
        user: localUser.email!,
        password: password,
        type: UserType.providerUser,
      ),
    );

    if (!result.success || result.user == null) {
      return false;
    }

    await saveUser(result.user!);

    return true;
  }

  static Future<void> updateUserFields({
    int? userid,
    String? username,
    String? phone,
    String? email,
    String? password,
    int? gender,
    int? age,
    int? type,
    String? nationality,
    bool? isActive,
    DateTime? joinDate,
    String? referralCode,
    Uint8List? image,
    String? fcmToken,
    int? defaultcarid,

    // =========================
    // ProviderDetailsRequest
    // =========================
    int? providerId,
    String? providerName,
    String? providerLatinName,
    String? providerDescription,
    String? providerLatinDescription,
    int? provid,
    String? cr,
    String? vatno,
    int? packageid,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    String? iban,
    String? nationalAddress,
    Uint8List? crimage,
    Uint8List? vatnoimage,
    Uint8List? ibanimage,
    bool? isApproved,

    // =========================
    // ApprovalInfo
    // =========================
    int? approvalInfoId,
    DateTime? approvalStartDate,
    DateTime? approvalEndDate,
    bool? approvalIsActive,
  }) async {
    final savedData = await _storage.read(
      key: userKey,
    );

    if (savedData == null || savedData.isEmpty) {
      return;
    }

    final Map<String, dynamic> data =
    Map<String, dynamic>.from(
      jsonDecode(savedData),
    );

    // =========================================================
    // CREATE USER
    // =========================================================

    if (userid != null) {
      data['userid'] = userid;
    }

    if (username != null) {
      data['username'] = username;
    }

    if (phone != null) {
      data['phone'] = phone;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (password != null) {
      data['password'] = password;
    }

    if (gender != null) {
      data['gender'] = gender;
    }

    if (age != null) {
      data['age'] = age;
    }

    if (type != null) {
      data['type'] = type;
    }

    if (nationality != null) {
      data['nationality'] = nationality;
    }

    if (isActive != null) {
      data['isactive'] = isActive;
    }

    if (joinDate != null) {
      data['joindate'] = joinDate.toIso8601String();
    }

    if (referralCode != null) {
      data['referralcode'] = referralCode;
    }

    if (image != null) {
      data['image'] = base64Encode(image);
    }

    if (fcmToken != null) {
      data['fcmtoken'] = fcmToken;
    }

    if (defaultcarid != null) {
      data['defaultcarid'] = defaultcarid;
    }

    // =========================================================
    // PROVIDER DETAILS
    // =========================================================

    if (data['providerDetails'] is Map) {
      final providerData =
      Map<String, dynamic>.from(
        data['providerDetails'],
      );

      if (providerId != null) {
        providerData['id'] = providerId;
      }

      if (providerName != null) {
        providerData['name'] = providerName;
      }

      if (providerLatinName != null) {
        providerData['latinname'] =
            providerLatinName;
      }

      if (providerDescription != null) {
        providerData['description'] =
            providerDescription;
      }

      if (providerLatinDescription != null) {
        providerData['latindesc'] =
            providerLatinDescription;
      }

      if (provid != null) {
        providerData['provid'] = provid;
      }

      if (cr != null) {
        providerData['cr'] = cr;
      }

      if (vatno != null) {
        providerData['vatno'] = vatno;
      }

      if (packageid != null) {
        providerData['packageid'] = packageid;
      }

      if (subscriptionStartDate != null) {
        providerData['subscriptionstartdate'] =
            subscriptionStartDate.toIso8601String();
      }

      if (subscriptionEndDate != null) {
        providerData['subscriptionenddate'] =
            subscriptionEndDate.toIso8601String();
      }

      if (iban != null) {
        providerData['iban'] = iban;
      }

      if (nationalAddress != null) {
        providerData['nationaladdress'] =
            nationalAddress;
      }

      if (crimage != null) {
        providerData['crimage'] =
            base64Encode(crimage);
      }

      if (vatnoimage != null) {
        providerData['vatnoimage'] =
            base64Encode(vatnoimage);
      }

      if (ibanimage != null) {
        providerData['ibanimage'] =
            base64Encode(ibanimage);
      }

      // =======================================================
      // ONLY isApproved
      // =======================================================

      if (isApproved != null) {
        providerData['isApproved'] =
            isApproved;
      }

      // =======================================================
      // APPROVAL INFO
      // =======================================================

      if (approvalInfoId != null ||
          approvalStartDate != null ||
          approvalEndDate != null ||
          approvalIsActive != null) {

        final approvalData =
        providerData['approvalInfo'] is Map
            ? Map<String, dynamic>.from(
          providerData['approvalInfo'],
        )
            : <String, dynamic>{};

        if (approvalInfoId != null) {
          approvalData['approvalinfoid'] =
              approvalInfoId;
        }

        if (approvalStartDate != null) {
          approvalData['approvalstartdate'] =
              approvalStartDate.toIso8601String();
        }

        if (approvalEndDate != null) {
          approvalData['approvalenddate'] =
              approvalEndDate.toIso8601String();
        }

        if (approvalIsActive != null) {
          approvalData['isactive'] =
              approvalIsActive;
        }

        providerData['approvalInfo'] =
            approvalData;
      }

      data['providerDetails'] =
          providerData;
    }

    // =========================================================
    // SAVE EXACT OLD DATA + ONLY CHANGES
    // =========================================================

    await _storage.write(
      key: userKey,
      value: jsonEncode(data),
    );
  }
}