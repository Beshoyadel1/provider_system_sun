import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_functions/user/create_user_model/create_user_request.dart';

class UserLocalStorage {

  static Future<void> saveUser(CreateUserRequest user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "user",
      jsonEncode(user.toJson()),
    );
  }

  static Future<CreateUserRequest?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString("user");

    if (userString == null) return null;

    return CreateUserRequest.fromJson(
      jsonDecode(userString),
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
  }
}