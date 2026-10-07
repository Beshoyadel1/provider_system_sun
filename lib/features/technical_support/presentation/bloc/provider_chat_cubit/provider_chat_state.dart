import 'package:equatable/equatable.dart';
import 'package:sun_web_system/features/technical_support/data/model/provider_chat_model.dart';

class ProviderChatState extends Equatable {
  final List<GetAllMessagesModel> allMessages;
  final List<GetAllMessagesModel> filteredMessages;
  final List<WorkTeamMemberModel> workTeam;
  final GetAllMessagesModel? selectedChat;
  final int selectedTab; // 0 = Messages, 1 = Work Team
  final String searchQuery;
  final bool isLoadingMessages;
  final bool isLoadingWorkTeam;
  final bool isSendingMessage;
  final bool isLoadingOlder;
  final String? errorMessage;
  final bool chatClosed;

  const ProviderChatState({
    this.allMessages = const [],
    this.filteredMessages = const [],
    this.workTeam = const [],
    this.selectedChat,
    this.selectedTab = 0,
    this.searchQuery = '',
    this.isLoadingMessages = false,
    this.isLoadingWorkTeam = false,
    this.isSendingMessage = false,
    this.isLoadingOlder = false,
    this.errorMessage,
    this.chatClosed = false,
  });

  ProviderChatState copyWith({
    List<GetAllMessagesModel>? allMessages,
    List<GetAllMessagesModel>? filteredMessages,
    List<WorkTeamMemberModel>? workTeam,
    GetAllMessagesModel? selectedChat,
    bool clearSelectedChat = false,
    int? selectedTab,
    String? searchQuery,
    bool? isLoadingMessages,
    bool? isLoadingWorkTeam,
    bool? isSendingMessage,
    bool? isLoadingOlder,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? chatClosed,
  }) {
    return ProviderChatState(
      allMessages: allMessages ?? this.allMessages,
      filteredMessages: filteredMessages ?? this.filteredMessages,
      workTeam: workTeam ?? this.workTeam,
      selectedChat: clearSelectedChat ? null : (selectedChat ?? this.selectedChat),
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingWorkTeam: isLoadingWorkTeam ?? this.isLoadingWorkTeam,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      chatClosed: chatClosed ?? this.chatClosed,
    );
  }

  int calculateTotalUnread(int currentUserId, int currentUserType) {
    int count = 0;
    for (final chat in allMessages) {
      count += chat.unreadCount(currentUserId, currentUserType);
    }
    return count;
  }

  int get totalUnreadCount => calculateTotalUnread(0, 0);

  @override
  List<Object?> get props => [
        allMessages,
        filteredMessages,
        workTeam,
        selectedChat,
        selectedTab,
        searchQuery,
        isLoadingMessages,
        isLoadingWorkTeam,
        isSendingMessage,
        isLoadingOlder,
        errorMessage,
        chatClosed,
      ];
}
