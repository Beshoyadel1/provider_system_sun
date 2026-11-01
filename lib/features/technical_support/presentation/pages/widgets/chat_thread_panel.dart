import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theming/colors.dart';
import '../../bloc/provider_chat_cubit/provider_chat_cubit.dart';
import '../../bloc/provider_chat_cubit/provider_chat_state.dart';
import 'chat_compose_bar.dart';
import 'chat_empty_view.dart';
import 'chat_messages_scroll_view.dart';
import 'chat_thread_header.dart';

class ChatThreadPanel extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;

  const ChatThreadPanel({
    super.key,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderChatCubit, ProviderChatState>(
      builder: (context, state) {
        final cubit = context.read<ProviderChatCubit>();
        final activeChat = state.selectedChat;

        if (activeChat == null) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: showBackButton
                ? AppBar(leading: BackButton(onPressed: onBack))
                : null,
            body: const ChatEmptyView(),
          );
        }

        return Container(
          color: AppColors.whiteColor,
          child: Column(
            children: [
              ChatThreadHeader(
                chat: activeChat,
                showBackButton: showBackButton,
                onBack: onBack,
              ),
              if (state.errorMessage != null)
                TextButton.icon(
                  onPressed:
                      state.isLoadingOlder ? null : cubit.reloadSelectedChat,
                  icon: const Icon(Icons.refresh),
                  label: Text(Localizations.localeOf(context).languageCode ==
                          'ar'
                      ? 'تعذّر إتمام العملية. إعادة تحميل المحادثة'
                      : 'Could not complete the request. Reload conversation'),
                ),
              Expanded(
                child: ChatMessagesScrollView(
                  key: ValueKey(state.selectedConversationRevision),
                  messages: activeChat.messages ?? [],
                  noOldMessages: activeChat.noOldMessages,
                  isLoadingOlder: state.isLoadingOlder,
                  onLoadOlder: () => cubit.getOlderMessages(),
                  currentUserId: cubit.currentUserId,
                  currentUserType: cubit.currentUserType,
                ),
              ),
              if (cubit.selectedChatIsClosed)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'المحادثة مغلقة'
                          : 'Conversation closed'),
                ),
              ChatComposeBar(
                key: ValueKey(state.selectedConversationRevision),
                isSending: state.isSendingMessage,
                isClosed: cubit.selectedChatIsClosed,
                onSend: (text) => cubit.sendMessage(text),
              ),
            ],
          ),
        );
      },
    );
  }
}
