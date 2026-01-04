import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {}

class LoginState extends AuthState {}
class SignupState extends AuthState {}
class AuthInitial extends AuthState {}