import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/api_functions/user/create_user_model/create_user_repository.dart';
import '../../../../core/api_functions/user/create_user_model/create_user_request.dart';
import '../../../../core/api_functions/user/login_model/login_repository.dart';
import '../../../../core/api_functions/user/login_model/login_request.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String otpCode = "";

  String phoneNumber = "";

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  bool get isPasswordObscure => _isPasswordObscure;
  bool get isConfirmPasswordObscure => _isConfirmPasswordObscure;

  void updatePhone(String phone) {
    phoneNumber = phone;
    emit(AuthInitial()); // optional state
  }

  void togglePasswordVisibility() {
    _isPasswordObscure = !_isPasswordObscure;
    emit(AuthPasswordVisibilityChanged());
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
    emit(AuthPasswordVisibilityChanged());
  }

  void showLogin() => emit(AuthShowLogin());
  void showSignup() => emit(AuthShowSignup());

  Future<void> login(LoginRequest request) async {
    emit(AuthLoginLoading());

    final bool isSuccess =
    await loginFunction(loginRequest: request);

    if (isSuccess) {
      emit(AuthLoginSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> signup(CreateUserRequest request) async {
    emit(AuthSignupLoading());

    final bool isSuccess =
    await createUserFunction(createUserRequest: request);

    if (isSuccess) {
      emit(AuthSignupSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  // ================= Validators =================

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authCompanyNameRequired;
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authEmailRequired;
    } else if (!isValidEmail(value)) {
      return AppLanguageKeys.authEnterCorrectEmail;
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authPasswordRequired;
    } else if (value.length < 6) {
      return AppLanguageKeys.authWeakPassword;
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authPhoneNumberRequired;
    }

    final cleanNumber =
    value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.length < 8 || cleanNumber.length > 15) {
      return AppLanguageKeys.authEnterCorrectPhoneNumber;
    }

    return null;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email.trim());
  }
}
