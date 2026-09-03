import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/send_verification_code_datasource/send_verification_code_datasource.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:sun_web_system/features/auth_page/data/request/change_password_request/change_password_request.dart';
import 'package:sun_web_system/features/auth_page/data/request/check_if_user_exist_or_not_request/check_if_user_exist_or_not_request.dart';
import 'package:sun_web_system/features/auth_page/data/request/check_if_user_exist_request/check_if_user_exist_request.dart';
import 'package:sun_web_system/features/auth_page/data/request/login_request/login_request.dart';
import 'package:sun_web_system/features/auth_page/domain/validation/facility_validator_result.dart';
import 'package:sun_web_system/features/notifications/data/datasource/signalr_datasource/signalr_service/signalr_service.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/work_time_cubit/work_time_cubit.dart';
import '../../../data/datasource/check_if_user_exist_or_not_datasource/check_if_user_exist_or_not_repository.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../features/auth_page/presentation/pages/change_password/change_password_page.dart';
import '../../../data/datasource/change_password_datasource/change_password_repository.dart';
import '../../../data/datasource/check_if_user_exist_datasource/check_if_user_exist_repository.dart';
import '../../../../../../core/language/language.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../data/datasource/create_user_datasource/create_user_repository.dart';
import '../../../data/model/create_user_model/create_user_request.dart';
import '../../../data/datasource/login_datasource/login_repository.dart';
import '../../../data/request/send_verification_code_request/send_verification_code_request.dart';
import 'auth_state.dart';

enum OtpPurpose {
  forgotPassword,
  signup,
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  String phoneNumber = "";

  bool _isConfirmPasswordObscure = true;

  bool get isConfirmPasswordObscure => _isConfirmPasswordObscure;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  CreateUserRequest? _checkUser;
  void setCheckUser(CreateUserRequest user) {
    _checkUser = user;

    print("CHECK USER => temporary data updated");
  }

  void clearCheckUser() {
    _checkUser = null;

    print("CHECK USER => cleared");
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(AuthPasswordVisibilityChanged());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(AuthPasswordVisibilityChanged());
  }

  Future<void> init() async {
    emit(AuthLoading());

    final localUser = await AuthLocalStorage.getUser();
    final password = await AuthLocalStorage.getPassword();

    if (localUser == null || password == null) {
      emit(AuthUnauthenticated());
      return;
    }

    final result = await loginFunction(
      loginRequest: LoginRequest(
        user: localUser.email!,
        password: password,
        type: UserType.providerUser,
      ),
    );

    // Login API failed
    if (!result.success || result.user == null) {
      await _forceLogout();
      return;
    }

    final apiUser = result.user!;

    // Local user must be exactly the same as API user
    // if (!localUser.isSameData(apiUser)) {
    //   print("INIT => Local user != API user");
    //
    //   await _forceLogout();
    //   return;
    // }

    print("INIT => Local user == API user");

    // Connect SignalR
    if (!SignalRService.instance.isConnected) {
      await SignalRService.instance.connect(
        hubUrl: ApiLink.notificationHub,
      );
    }

    // Check facility completion
    await _checkFacilityCompletion(apiUser);
  }

  Future<void> _forceLogout() async {
    await AuthLocalStorage.clearUser();
    await AuthLocalStorage.clearPassword();

    await SignalRService.instance.disconnect();

    emit(AuthUnauthenticated());
  }

  Future<void> login(LoginRequest request) async {
    emit(AuthLoginLoading());

    final result = await loginFunction(
      loginRequest: request,
    );

    if (!result.success || result.user == null) {
      emit(
        AuthLoginError(
          result.message,
        ),
      );
      return;
    }

    final apiUser = result.user!;

    // First login → save API user
    await AuthLocalStorage.saveUser(apiUser);
    // Save password for auto-login after restart
    await AuthLocalStorage.savePassword(request.password);

    if (!SignalRService.instance.isConnected) {
      await SignalRService.instance.connect(
        hubUrl: ApiLink.notificationHub,
      );
    }

    emit(
      AuthLoginSuccess(
        message: result.message,
      ),
    );

    await _checkFacilityCompletion(apiUser);
  }

  Future<void> logout(BuildContext context) async {
    emit(AuthLoading());
    _forceLogout();
    // if (context.mounted) {
    //   Navigator.pop(context);
    // }
    emit(AuthUnauthenticated());
  }

  Future<void> _checkFacilityCompletion(CreateUserRequest user) async {
    final branchCubit = BranchCubit();
    final workTimeCubit = UpdateWorkTimeCubit();

    await Future.wait([
      branchCubit.getProviderBranches(),
      workTimeCubit.getWorkTimes(),
    ]);

    print("BRANCHES => ${branchCubit.branches.length}");
    print("WORK TIMES => ${workTimeCubit.workTimes.length}");

    final result = FacilityValidator.validate(
      user: user,
      branchCubit: branchCubit,
      workTimeCubit: workTimeCubit,
    );

    print("IS VALID => ${result.isValid}");
    print("MISSING FIELDS => ${result.missingFields}");

    if (result.isValid) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthIncompleteProfile(result.missingFields));
    }
  }

  Future<void> reCheckFacility() async {
    final user = _checkUser ?? await AuthLocalStorage.getUser();

    if (user == null) {
      print("RECHECK => AuthUnauthenticated");

      emit(AuthUnauthenticated());

      return;
    }

    print("RECHECK => validating current data");

    final branchCubit = BranchCubit();
    final workTimeCubit = UpdateWorkTimeCubit();

    await Future.wait([
      branchCubit.getProviderBranches(),
      workTimeCubit.getWorkTimes(),
    ]);

    final result = FacilityValidator.validate(
      user: user,
      branchCubit: branchCubit,
      workTimeCubit: workTimeCubit,
    );

    if (result.isValid) {
      print("RECHECK => VALID");

      emit(AuthAuthenticated());
    } else {
      print(
        "RECHECK => INVALID: ${result.missingFields}",
      );

      emit(
        AuthIncompleteProfile(
          result.missingFields,
        ),
      );
    }
  }

  static Future<void> saveUserFromRequest(CreateUserRequest request) async {
    await AuthLocalStorage.saveUser(request);
  }

  Future<void> checkAuth() async {
    final isLoggedIn = await AuthLocalStorage.isLoggedIn();
    if (state is AuthUpdateLoading || state is AuthUpdateSuccess) {
      return;
    }

    if (state is AuthAuthenticated && isLoggedIn) {
      return;
    }

    if (isLoggedIn) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<bool> updateUser(
    CreateUserRequest request,
  ) async {
    if (isClosed) return false;

    emit(AuthUpdateLoading());

    try {
      final oldUser = await AuthLocalStorage.getUser();

      if (oldUser == null) {
        emit(
          AuthUpdateError(
            'User not found',
          ),
        );

        return false;
      }

      // =========================================================
      // PROVIDER MERGE
      // =========================================================

      final oldProvider = oldUser.providerDetails;

      final newProvider = request.providerDetails;

      final ProviderDetailsRequest? mergedProvider = newProvider != null
          ? ProviderDetailsRequest(
              id: newProvider.id ?? oldProvider?.id,
              name: newProvider.name ?? oldProvider?.name,
              latinname: newProvider.latinname ?? oldProvider?.latinname,
              description: newProvider.description ?? oldProvider?.description,
              latindesc: newProvider.latindesc ?? oldProvider?.latindesc,
              provid: newProvider.provid ?? oldProvider?.provid,
              cr: newProvider.cr ?? oldProvider?.cr,
              vatno: newProvider.vatno ?? oldProvider?.vatno,
              packageid: newProvider.packageid ?? oldProvider?.packageid,
              subscriptionstartdate: newProvider.subscriptionstartdate ??
                  oldProvider?.subscriptionstartdate,
              subscriptionenddate: newProvider.subscriptionenddate ??
                  oldProvider?.subscriptionenddate,
              iban: newProvider.iban ?? oldProvider?.iban,
              nationaladdress:
                  newProvider.nationaladdress ?? oldProvider?.nationaladdress,
              crimage: newProvider.crimage ?? oldProvider?.crimage,
              vatnoimage: newProvider.vatnoimage ?? oldProvider?.vatnoimage,
              ibanimage: newProvider.ibanimage ?? oldProvider?.ibanimage,
              isApproved: newProvider.isApproved ?? oldProvider?.isApproved,
              approvalInfo:
                  newProvider.approvalInfo ?? oldProvider?.approvalInfo,
            )
          : oldProvider;

      // =========================================================
      // USER MERGE
      // =========================================================

      final mergedRequest = CreateUserRequest(
        // NEVER change unless request has a new value
        userid: oldUser.userid,

        username: request.username ?? oldUser.username,

        phone: request.phone ?? oldUser.phone,

        email: request.email ?? oldUser.email,

        password: request.password ?? oldUser.password,

        gender: request.gender ?? oldUser.gender,

        age: request.age ?? oldUser.age,

        type: oldUser.type,

        nationality: request.nationality ?? oldUser.nationality,

        isActive: request.isActive ?? oldUser.isActive,

        joinDate: request.joinDate ?? oldUser.joinDate,

        referralCode: request.referralCode ?? oldUser.referralCode,

        image: request.image ?? oldUser.image,

        fcmToken: request.fcmToken ?? oldUser.fcmToken,

        defaultcarid: request.defaultcarid ?? oldUser.defaultcarid,

        providerDetails: mergedProvider,

        employeeDetails: request.employeeDetails ?? oldUser.employeeDetails,

        adminDetails: request.adminDetails ?? oldUser.adminDetails,

        companyDetails: request.companyDetails ?? oldUser.companyDetails,

        driverDetails: request.driverDetails ?? oldUser.driverDetails,
      );

      // =========================================================
      // API
      // =========================================================

      final result = await updateUserFunction(
        createUserRequest: mergedRequest,
      );

      if (isClosed) {
        return false;
      }
      if (result.success) {
        await AuthLocalStorage.saveUser(
          mergedRequest,
        );

        emit(
          AuthUpdateSuccess(
            result.message,
          ),
        );

        return true;
      }

      // =========================================================
      // ERROR
      // =========================================================

      emit(
        AuthUpdateError(
          result.message,
        ),
      );

      return false;
    } catch (e) {
      if (isClosed) {
        return false;
      }

      emit(
        AuthUpdateError(
          e.toString(),
        ),
      );

      return false;
    }
  }

  String? verificationEmail;
  String? verificationPhone;

  String otpCode = "";

  OtpPurpose? _otpPurpose;

  Timer? _timer;
  int secondsRemaining = 30;

  bool isOtpError = false;
  bool _isOtpVerified = false;
  bool _isResendingOtp = false;
  bool _isCompletingSignup = false;
  bool _isStartingSignup = false;

  bool get isOtpVerified => _isOtpVerified;
  bool get isCompletingSignup => _isCompletingSignup;

  void generateOtp() {
    final random = Random();

    otpCode = (1000 + random.nextInt(9000)).toString();
    _isOtpVerified = false;

    startTimer();

    isOtpError = false;

    emit(AuthOtpGenerated());
  }

  void startTimer() {
    secondsRemaining = 30;

    _timer?.cancel();

    emit(AuthOtpTimer());

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (isClosed) {
          timer.cancel();
          return;
        }

        if (secondsRemaining <= 0) {
          timer.cancel();

          emit(AuthOtpExpired());
          return;
        }

        secondsRemaining--;

        emit(AuthOtpTimer());
      },
    );
  }

  void resetOtpError() {
    if (isClosed) return;

    if (isOtpError) {
      isOtpError = false;

      emit(
        AuthOtpReset(),
      );
    }
  }

  static String buildOtpMessage({
    required String otp,
    required OtpPurpose purpose,
    required String languageCode,
  }) {
    final locale = Locale(languageCode == 'en' ? 'en' : 'ar');
    final localizations = AppLocalizations(locale);
    final key = purpose == OtpPurpose.signup
        ? AppLanguageKeys.signupOtpMessage
        : AppLanguageKeys.forgotPasswordOtpMessage;

    return localizations.translate(key).replaceAll('{otp}', otp);
  }

  void validateOtp(String code) {
    if (isClosed) return;
    if (_isOtpVerified) return;

    final enteredOtp = code.trim();

    if (secondsRemaining <= 0) {
      isOtpError = true;

      emit(
        AuthOtpError(
          AppLanguageKeys.badRequestError,
        ),
      );

      return;
    }

    if (enteredOtp.length != 4) {
      isOtpError = true;

      emit(
        AuthOtpError(
          AppLanguageKeys.wrongCode,
        ),
      );

      return;
    }

    if (enteredOtp != otpCode) {
      isOtpError = true;

      emit(
        AuthOtpError(
          AppLanguageKeys.wrongCode,
        ),
      );

      return;
    }

    // ==========================================
    // OTP CORRECT
    // ==========================================

    isOtpError = false;
    _isOtpVerified = true;
    _timer?.cancel();
    emit(AuthOtpSuccess());
  }

  Future<void> resendOtp({required String languageCode}) async {
    if (isClosed) return;
    if (_isResendingOtp || _isCompletingSignup) return;

    final phone = verificationPhone;

    if (phone == null || phone.trim().isEmpty) {
      emit(
        AuthOtpError(
          AppLanguageKeys.phoneNumberNotFound,
        ),
      );
      return;
    }

    final purpose = _otpPurpose;

    if (purpose == null) {
      emit(
        AuthOtpError(
          AppLanguageKeys.somethingWentWrong,
        ),
      );
      return;
    }

    final newOtp = (1000 + Random().nextInt(9000)).toString();
    final message = buildOtpMessage(
      otp: newOtp,
      purpose: purpose,
      languageCode: languageCode,
    );

    _isResendingOtp = true;
    try {
      final result = await sendVerificationCodeFunction(
        request: SendVerificationCodeRequest(
          user: phone,
          message: message,
        ),
      );

      if (isClosed) return;

      if (result) {
        otpCode = newOtp;
        _isOtpVerified = false;
        isOtpError = false;
        startTimer();
        emit(
          AuthOtpResendSuccess(),
        );
      } else {
        emit(
          AuthOtpError(
            AppLanguageKeys.somethingWentWrong,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        AuthOtpError(
          e.toString(),
        ),
      );
    } finally {
      _isResendingOtp = false;
    }
  }

  // void resendOtp() {
  //   generateOtp();
  //   isOtpError = false;
  //   emit(AuthOtpGenerated());
  // }

  void updatePhone(String phone) {
    phoneNumber = phone;
    emit(AuthInitial());
  }

  Future<bool> sendOtp({
    required String email,
    required String phone,
    required OtpPurpose purpose,
    required String languageCode,
  }) async {
    if (isClosed) return false;

    _timer?.cancel();
    otpCode = '';
    _otpPurpose = null;
    _isOtpVerified = false;
    isOtpError = false;
    secondsRemaining = 0;

    verificationEmail = email.trim();
    verificationPhone = phone.trim();

    final random = Random();

    final newOtp = (1000 + random.nextInt(9000)).toString();

    final message = buildOtpMessage(
      otp: newOtp,
      purpose: purpose,
      languageCode: languageCode,
    );

    try {
      final sent = await _sendOtpToPhoneVariations(
        phone: phone.trim(),
        message: message,
      );

      if (isClosed) return false;

      if (!sent) {
        return false;
      }

      otpCode = newOtp;
      _otpPurpose = purpose;
      _isOtpVerified = false;
      isOtpError = false;

      startTimer();

      return true;
    } catch (e) {
      if (isClosed) return false;

      return false;
    }
  }

  Future<void> checkIfUserExistOrNot({
    required String email,
    required String languageCode,
  }) async {
    if (isClosed) return;

    emit(
      CheckIfUserExistOrNotLoading(),
    );

    try {
      final result = await checkIfUserExistOrNotFunction(
        request: CheckIfUserExistOrNotRequest(
          user: email,
          type: UserType.providerUser,
        ),
      );

      if (isClosed) return;

      if (result == null || result.isEmpty) {
        emit(
          CheckIfUserExistOrNotError(
            AppLanguageKeys.userNotFound,
          ),
        );
        return;
      }

      final user = result.first;

      if (user.value != true) {
        emit(
          CheckIfUserExistOrNotNotFound(
            user,
          ),
        );
        return;
      }

      final phone = user.phone?.trim();

      if (phone == null || phone.isEmpty) {
        emit(
          CheckIfUserExistOrNotError(
            AppLanguageKeys.phoneNumberNotFoundForThisAccount,
          ),
        );
        return;
      }

      final sent = await sendOtp(
        email: email,
        phone: phone,
        purpose: OtpPurpose.forgotPassword,
        languageCode: languageCode,
      );

      if (isClosed) return;

      if (sent) {
        emit(
          CheckIfUserExistOrNotSuccess(
            user,
          ),
        );

        return;
      }

      emit(
        CheckIfUserExistOrNotError(
          AppLanguageKeys.failedToSendVerificationCode,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CheckIfUserExistOrNotError(
          e.toString(),
        ),
      );
    }
  }

  List<String> _getPhoneVariations(String phone) {
    final original = phone.trim();

    final List<String> phones = [];

    // 1. Original
    phones.add(original);

    // 2. Remove 966
    if (original.startsWith('966')) {
      final without966 = original.substring(3);

      if (without966.isNotEmpty) {
        phones.add(without966);

        // 3. Remove 966 + add 0
        phones.add('0$without966');
      }
    }

    return phones.toSet().toList();
  }

  Future<bool> _sendOtpToPhoneVariations({
    required String phone,
    required String message,
  }) async {
    final phones = _getPhoneVariations(phone);

    for (final phoneNumber in phones) {
      if (isClosed) return false;

      final result = await sendVerificationCodeFunction(
        request: SendVerificationCodeRequest(
          user: phoneNumber,
          message: message,
        ),
      );

      if (result) {
        verificationPhone = phoneNumber;
        return true;
      }
    }

    return false;
  }

  Future<void> changePassword({
    required String user,
    required String password,
  }) async {
    if (isClosed) return;

    emit(ChangePasswordLoading());

    try {
      final result = await changePasswordFunction(
        changePasswordRequest: ChangePasswordRequest(
          user: user,
          password: password,
          type: UserType.providerUser,
        ),
      );

      if (isClosed) return;

      if (result.success) {
        emit(
          ChangePasswordSuccess(
            result.message,
          ),
        );
      } else {
        emit(
          ChangePasswordError(
            result.message,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        ChangePasswordError(
          e.toString(),
        ),
      );
    }
  }

  CreateUserRequest? _pendingSignup;

  CreateUserRequest? get pendingSignup => _pendingSignup;

  void clearPendingSignup() {
    _pendingSignup = null;
  }

  void cancelSignupOtp() {
    if (_otpPurpose != OtpPurpose.signup) return;

    _timer?.cancel();
    _pendingSignup = null;
    otpCode = '';
    _otpPurpose = null;
    _isOtpVerified = false;
    isOtpError = false;
    secondsRemaining = 0;
    verificationEmail = null;
    verificationPhone = null;
  }

  Future<void> signup(
    CreateUserRequest request, {
    required String languageCode,
  }) async {
    if (isClosed) return;
    if (_isStartingSignup) return;

    _isStartingSignup = true;
    cancelSignupOtp();
    emit(AuthSignupLoading());

    try {
      // =========================================================
      // 1. GET & VALIDATE DATA
      // =========================================================

      final email = request.email?.trim() ?? '';
      final phone = request.phone?.trim() ?? '';
      final username = request.username?.trim() ?? '';
      final password = request.password?.trim() ?? '';
      final providerName = request.providerDetails?.name?.trim() ?? '';
      final providerLatinName =
          request.providerDetails?.latinname?.trim() ?? '';

      if (username.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          password.isEmpty ||
          providerName.isEmpty ||
          providerLatinName.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.enterYourData,
          ),
        );
        return;
      }

      if (password.length < 6) {
        emit(
          AuthSignupError(
            AppLanguageKeys.passwordAtLeastKey,
          ),
        );
        return;
      }

      // =========================================================
      // 2. CHECK EMAIL FORMAT
      // =========================================================

      if (!isValidEmail(email)) {
        emit(
          AuthSignupError(
            AppLanguageKeys.pleaseEnterValidEmail,
          ),
        );
        return;
      }

      // =========================================================
      // 3. CHECK IF EMAIL ALREADY EXISTS
      // =========================================================

      final existingUsers = await checkIfUserExistOrNotFunction(
        request: CheckIfUserExistOrNotRequest(
          user: email,
          type: UserType.providerUser,
        ),
      );

      if (isClosed) return;

      // =========================================================
      // 4. CHECK API RESULT
      // =========================================================

      if (existingUsers == null || existingUsers.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.somethingWentWrong,
          ),
        );
        return;
      }

      final user = existingUsers.first;

      // =========================================================
      // 5. EMAIL ALREADY EXISTS
      // =========================================================

      if (user.value == true) {
        emit(
          AuthSignupError(
            AppLanguageKeys.emailExist,
          ),
        );
        return;
      }

      // =========================================================
      // 6. EMAIL AVAILABLE
      // Save request BEFORE sending OTP
      // =========================================================

      _pendingSignup = request;

      // =========================================================
      // 7. SEND OTP
      // =========================================================

      final sent = await sendOtp(
        email: email,
        phone: phone,
        purpose: OtpPurpose.signup,
        languageCode: languageCode,
      );

      if (isClosed) return;

      // =========================================================
      // 8. OTP FAILED
      // =========================================================

      if (!sent) {
        _pendingSignup = null;

        emit(
          AuthSignupError(
            AppLanguageKeys.failedToSendVerificationCode,
          ),
        );

        return;
      }

      // =========================================================
      // 9. OTP SENT SUCCESSFULLY
      // =========================================================

      emit(
        AuthSignupSuccess(
          AppLanguageKeys.verificationCodeSent,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      _pendingSignup = null;

      emit(
        AuthSignupError(
          e.toString(),
        ),
      );
    } finally {
      _isStartingSignup = false;
    }
  }

  Future<void> completeSignupAfterOtp() async {
    if (isClosed) return;
    if (_isCompletingSignup) return;

    final request = _pendingSignup;

    if (request == null) {
      emit(
        AuthSignupError(
          AppLanguageKeys.somethingWentWrong,
        ),
      );
      return;
    }

    _isCompletingSignup = true;
    emit(AuthSignupLoading());

    try {
      final result = await createUserFunction(
        createUserRequest: request,
      );

      if (isClosed) return;

      if (!result.success) {
        emit(
          AuthSignupError(
            result.message,
          ),
        );
        return;
      }

      _pendingSignup = null;

      emit(
        AuthSignupCompleted(
          result.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        AuthSignupError(
          e.toString(),
        ),
      );
    } finally {
      _isCompletingSignup = false;
    }
  }

// ================= Validators ================

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }

  static String? employeePhoneValidationError(String? phone) {
    final value = phone?.trim() ?? '';

    if (value.isEmpty) {
      return AppLanguageKeys.authPhoneNumberRequired;
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) {
      return AppLanguageKeys.phoneNumberAtLeastSixDigits;
    }

    return null;
  }

// =========================================================
// SIGNUP EMPLOYEE
// Check Email + Phone -> Create User
// NO OTP
// =========================================================

  Future<void> signupEmp(CreateUserRequest request) async {
    if (isClosed) return;

    emit(AuthSignupLoading());

    try {
      // =====================================================
      // 1. GET DATA
      // =====================================================

      final email = request.email?.trim() ?? '';
      final phone = request.phone?.trim() ?? '';

      if (email.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.enterYourData,
          ),
        );
        return;
      }

      final phoneError = employeePhoneValidationError(phone);
      if (phoneError != null) {
        emit(
          AuthSignupError(phoneError),
        );
        return;
      }

      // =====================================================
      // 2. VALIDATE EMAIL
      // =====================================================

      if (!isValidEmail(email)) {
        emit(
          AuthSignupError(
            AppLanguageKeys.pleaseEnterValidEmail,
          ),
        );
        return;
      }

      // =====================================================
      // 3. CHECK EMAIL
      // =====================================================

      print('=================================');
      print('CHECK EMPLOYEE EMAIL');
      print('EMAIL => $email');
      print('=================================');

      final emailResult = await checkIfUserExistOrNotFunction(
        request: CheckIfUserExistOrNotRequest(
          user: email,
          type: UserType.employeeUser,
        ),
      );

      if (isClosed) return;

      print('EMAIL CHECK RESULT => $emailResult');

      // =====================================================
      // 4. EMAIL CHECK FAILED
      // =====================================================

      if (emailResult == null || emailResult.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.somethingWentWrong,
          ),
        );
        return;
      }

      final emailUser = emailResult.first;

      print(
        'EMAIL EXISTS => ${emailUser.value}',
      );

      // =====================================================
      // 5. EMAIL ALREADY EXISTS
      // =====================================================

      if (emailUser.value == true) {
        emit(
          AuthSignupError(
            AppLanguageKeys.emailExist,
          ),
        );
        return;
      }

      // =====================================================
      // 6. CHECK PHONE
      // =====================================================

      print('=================================');
      print('CHECK EMPLOYEE PHONE');
      print('PHONE => $phone');
      print('=================================');

      final phoneResult = await checkIfUserExistOrNotFunction(
        request: CheckIfUserExistOrNotRequest(
          user: phone,
          type: UserType.employeeUser,
        ),
      );

      if (isClosed) return;

      print('PHONE CHECK RESULT => $phoneResult');

      // =====================================================
      // 7. PHONE CHECK FAILED
      // =====================================================

      if (phoneResult == null || phoneResult.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.somethingWentWrong,
          ),
        );
        return;
      }

      final phoneUser = phoneResult.first;

      print(
        'PHONE EXISTS => ${phoneUser.value}',
      );

      // =====================================================
      // 8. PHONE ALREADY EXISTS
      // =====================================================

      if (phoneUser.value == true) {
        emit(
          AuthSignupError(
            AppLanguageKeys.phoneExist,
          ),
        );
        return;
      }

      // =====================================================
      // 9. EMAIL + PHONE AVAILABLE
      // =====================================================

      print('=================================');
      print('EMAIL AVAILABLE');
      print('PHONE AVAILABLE');
      print('CREATING EMPLOYEE');
      print('=================================');

      // =====================================================
      // 10. CREATE EMPLOYEE
      // =====================================================

      final result = await createUserFunction(
        createUserRequest: request,
      );

      if (isClosed) return;

      // =====================================================
      // 11. CREATE SUCCESS
      // =====================================================

      if (result.success) {
        emit(
          AuthSignupEmpCompleted(
            result.message,
          ),
        );
        return;
      }

      // =====================================================
      // 12. CREATE ERROR
      // =====================================================

      emit(
        AuthSignupError(
          result.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      print('=================================');
      print('EMPLOYEE SIGNUP ERROR');
      print('$e');
      print('=================================');

      emit(
        AuthSignupError(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
