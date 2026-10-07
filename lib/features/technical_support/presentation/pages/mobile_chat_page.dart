import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import '../bloc/provider_chat_cubit/provider_chat_cubit.dart';
import 'widgets/chat_thread_panel.dart';

class MobileChatPage extends StatelessWidget {
  const MobileChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ProviderChatCubit>();
    return BlocProvider.value(
      value: cubit,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) cubit.clearSelectedChat();
        },
        child: Scaffold(
      body: SafeArea(
        child: ChatThreadPanel(
          showBackButton: true,
          onBack: () => Navigator.of(context).maybePop(),
        ),
      ),
        ),
      ),
    );
  }
}
