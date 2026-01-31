import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/model/user/create_user_model/create_user_repository.dart';
import 'package:sun_web_system/core/model/user/create_user_model/create_user_request.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/model/user/login_model/login_repository.dart';
import '../../../../../../core/model/user/login_model/login_request.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  bool get isPasswordObscure => _isPasswordObscure;
  bool get isConfirmPasswordObscure => _isConfirmPasswordObscure;

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

}
