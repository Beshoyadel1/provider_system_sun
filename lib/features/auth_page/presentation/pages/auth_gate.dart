import 'package:flutter/material.dart';
import 'package:sun_web_system/core/services/fcm_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_page.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/facility_account/facility_account_check.dart';
import '../../../store_page/presentation/pages/store_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      // Saving account data must keep the current page mounted. Its own
      // listeners handle loading, success and errors without changing access.
      buildWhen: (previous, current) =>
          current is! AuthUpdateLoading &&
          current is! AuthUpdateSuccess &&
          current is! AuthUpdateError,
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthIncompleteProfile) {
          return const FacilityAccountCheck();
        }

        if (state is AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) FcmService.instance.markUiReady();
          });
          return const StorePage();
        }

        return const LoginPage();
      },
    );
  }
}
