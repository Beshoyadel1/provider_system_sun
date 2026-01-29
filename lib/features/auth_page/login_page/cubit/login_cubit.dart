import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/auth_page/login_page/cubit/login_state.dart';
import '../../../../../../core/model/user/login_model/login_repository.dart';
import '../../../../../../core/model/user/login_model/login_request.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(LoginRequest request) async {
    emit(LoginLoading());

    try {
      bool isSuccess = await loginFunction(loginRequest: request);

      if (isSuccess) {
        // loading for 2 seconds before navigate
        await Future.delayed(const Duration(seconds: 2));
        emit(LoginSuccess());
      } else {
        emit(LoginError(AppLanguageKeys.wrongUsernameOrPassword));
      }
    } catch (e) {
      emit(LoginError(AppLanguageKeys.somethingWentWrong));
    }
  }
}
