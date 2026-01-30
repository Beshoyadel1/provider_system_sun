abstract class AuthState {}

// UI States
class AuthInitial extends AuthState {}

class AuthShowLogin extends AuthState {}

class AuthShowSignup extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginError extends AuthState {
  final String message;
  AuthLoginError(this.message);
}

class AuthSignupLoading extends AuthState {}

class AuthSignupSuccess extends AuthState {}

class AuthSignupError extends AuthState {
  final String message;
  AuthSignupError(this.message);
}
class AuthPasswordVisibilityChanged extends AuthState {}
