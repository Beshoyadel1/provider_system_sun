import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/setup_git_it.dart';
import '../../../../core/theming/colors.dart';
import '../bloc/provider_chat_cubit/provider_chat_cubit.dart';
import '../bloc/provider_chat_cubit/provider_chat_state.dart';
import 'mobile_chat_page.dart';
import 'widgets/chat_conversations_panel.dart';
import 'widgets/chat_thread_panel.dart';
import 'widgets/chat_work_team_panel.dart';
import '../../../../core/services/chat_route_observer.dart';

class ProviderChatPage extends StatefulWidget {
  const ProviderChatPage({super.key, this.isStandalone = false});
  final bool isStandalone;

  @override
  State<ProviderChatPage> createState() => _ProviderChatPageState();
}

class _ProviderChatPageState extends State<ProviderChatPage> {
  @override
  void initState() {
    super.initState();
    final cubit = getIt<ProviderChatCubit>();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProviderChatCubit>(),
      child: BlocListener<ProviderChatCubit, ProviderChatState>(
        listenWhen: (previous, current) =>
            previous.closedSelectedChatRevision !=
            current.closedSelectedChatRevision,
        listener: (context, state) {
          if (widget.isStandalone &&
              (ModalRoute.of(context)?.isCurrent ?? false) &&
              Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        child: ChatRouteVisibility(
          cubit: getIt<ProviderChatCubit>(),
          visible: MediaQuery.sizeOf(context).width >= 600,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: widget.isStandalone
                ? AppBar(
                    title: Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'المحادثات'
                            : 'Conversations'),
                  )
                : null,
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  if (widget.isStandalone) return const ChatThreadPanel();
                  return const _MobileChatLayout();
                } else if (constraints.maxWidth < 1024) {
                  return const _TabletChatLayout();
                } else {
                  return const _DesktopChatLayout();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopChatLayout extends StatelessWidget {
  const _DesktopChatLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 340,
          child: ChatConversationsPanel(),
        ),
        Expanded(
          child: ChatThreadPanel(),
        ),
        SizedBox(
          width: 280,
          child: ChatWorkTeamPanel(),
        ),
      ],
    );
  }
}

class _TabletChatLayout extends StatelessWidget {
  const _TabletChatLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 340,
          child: Column(
            children: [
              const _SidebarTabs(),
              Expanded(
                child: BlocBuilder<ProviderChatCubit, ProviderChatState>(
                  buildWhen: (prev, curr) =>
                      prev.selectedTab != curr.selectedTab,
                  builder: (context, state) {
                    return state.selectedTab == 0
                        ? const ChatConversationsPanel()
                        : const ChatWorkTeamPanel();
                  },
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: ChatThreadPanel(),
        ),
      ],
    );
  }
}

class _MobileChatLayout extends StatelessWidget {
  const _MobileChatLayout();

  void _navigateToMobileChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MobileChatPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SidebarTabs(),
        Expanded(
          child: BlocBuilder<ProviderChatCubit, ProviderChatState>(
            buildWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
            builder: (context, state) {
              return state.selectedTab == 0
                  ? ChatConversationsPanel(
                      onSelectChat: (_) => _navigateToMobileChat(context),
                    )
                  : ChatWorkTeamPanel(
                      onSelectMember: (_) => _navigateToMobileChat(context),
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _SidebarTabs extends StatelessWidget {
  const _SidebarTabs();

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return BlocBuilder<ProviderChatCubit, ProviderChatState>(
      buildWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
      builder: (context, state) {
        final cubit = context.read<ProviderChatCubit>();
        return Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _TabButton(
                  title: isAr ? 'المحادثات' : 'All Chats',
                  icon: Icons.chat_bubble_outline,
                  isSelected: state.selectedTab == 0,
                  onTap: () => cubit.selectTab(0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TabButton(
                  title: isAr ? 'فريق العمل' : 'Work Team',
                  icon: Icons.people_outline,
                  isSelected: state.selectedTab == 1,
                  onTap: () => cubit.selectTab(1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.mainColor : AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.mainColor : AppColors.cardStroke,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color:
                    isSelected ? AppColors.whiteColor : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
