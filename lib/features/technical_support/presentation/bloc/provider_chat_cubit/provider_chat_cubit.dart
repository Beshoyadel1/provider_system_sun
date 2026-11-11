import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/notifications/data/model/notification_payload.dart';
import 'package:sun_web_system/features/notifications/data/model/receive_message_notification_model/receive_message_notification_model.dart';
import 'package:sun_web_system/features/technical_support/data/datasource/provider_chat_repository.dart';
import 'package:sun_web_system/features/technical_support/data/model/chat_events/chat_events.dart';
import 'package:sun_web_system/features/technical_support/data/model/chat_identity.dart';
import 'package:sun_web_system/features/technical_support/data/model/provider_chat_model.dart';
import 'provider_chat_state.dart';

class ProviderChatCubit extends Cubit<ProviderChatState> {
  ProviderChatCubit({
    this.chatRepository = const ProviderChatRepository(),
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(const ProviderChatState()) {
    _chatEventsSub =
        ChatEvents.instance.stream.listen(_handleRealtimeChatEvent);
  }

  final ProviderChatRepository chatRepository;
  final DateTime Function() _now;
  StreamSubscription<ReceiveMessageData>? _chatEventsSub;
  int _cachedUserId = 0, _cachedUserType = 0, _session = 0, _localId = 0;
  bool _messagesLoaded = false, _teamLoaded = false;
  Future<void>? _summaryRequest;
  final Map<String, bool> _closedChats = {};
  final Map<String, Timer> _readTimers = {};
  final Set<String> _loadedThreads = {}, _pendingHistoryRefreshes = {};
  final Map<String, bool> _loadingThreads = {};
  final Map<String, ChatIdentity> _assignedPeers = {};
  final Map<String, int> _supportEpochs = {},
      _statusEpochs = {},
      _readRevisions = {};
  final Map<int, int> _arrivalRevisions = {};
  final Map<int, Set<int>> _knownIdsAtSend = {};
  final Set<int> _matchedMessageIds = {}, _deletedMessageIds = {};
  int _nextSupportEpoch = 0, _revision = 0, _sendSerial = 0;
  ChatIdentity? _sendingPeer;
  bool _ignoreRemoteSupport = false, _chatVisible = true;
  Object? _visibleOwner;

  int _epoch(ChatIdentity peer) => _supportEpochs[peer.key] ?? 0;
  bool _requestValid(int session, ChatIdentity peer, int epoch) =>
      _valid(session) &&
      (peer.type != UserType.adminUser || _epoch(peer) == epoch);
  bool containsMessage(int id) => state.allMessages
      .any((chat) => chat.messages?.any((m) => m.id == id) ?? false);

  bool isVisibleConversation(NotificationPayload payload) {
    final peer = payload.chatPeer(currentUserId, currentUserType);
    final selected = state.selectedChat;
    return _chatVisible &&
        peer != null &&
        selected != null &&
        _resolve(peer).key == _identity(selected).key &&
        (payload.integer('harageId') ?? 0) == 0;
  }

  void refreshVisibleChatFromPush(NotificationPayload payload) {
    final selected = state.selectedChat;
    if (isClosed ||
        !_chatVisible ||
        selected == null ||
        currentUserId <= 0 ||
        currentUserType <= 0 ||
        payload.kind != NotificationKind.chat ||
        payload.contextId('harageId') != 0 ||
        _deletedMessageIds.contains(payload.integer('id'))) {
      return;
    }

    final peer = _identity(selected);
    if (peer.type == UserType.adminUser && payload.contextId('orderId') != 0) {
      return;
    }
    final pushPeer = payload.chatPeer(currentUserId, currentUserType);
    if (pushPeer != null) {
      if (_resolve(pushPeer).key != peer.key) return;
    } else {
      final account = ChatIdentity(currentUserId, currentUserType);
      bool matchesField(String field, int expected) {
        final value = payload.get(field)?.toString().trim() ?? '';
        return value.isEmpty ||
            value.toLowerCase() == 'null' ||
            int.tryParse(value) == expected;
      }

      bool matchesEndpoint(String prefix, ChatIdentity endpoint) =>
          matchesField('${prefix}user', endpoint.id) &&
          matchesField('${prefix}usertype', endpoint.type);

      final incoming = matchesEndpoint('from', peer) &&
          matchesEndpoint('to', account);
      final outgoing = matchesEndpoint('from', account) &&
          matchesEndpoint('to', peer);
      if (!incoming && !outgoing) return;
    }

    _refreshVisibleHistory();
  }

  String? _loadingKey(ChatIdentity peer) => _loadingThreads.keys
      .where((key) => (_assignedPeers[key]?.key ?? key) == peer.key)
      .firstOrNull;

  void _refreshVisibleHistory() {
    final selected = state.selectedChat;
    if (isClosed || !_chatVisible || selected == null || selectedChatIsClosed) {
      return;
    }
    final loadingKey = _loadingKey(_identity(selected));
    if (loadingKey != null) {
      _pendingHistoryRefreshes.add(loadingKey);
      return;
    }
    unawaited(getOlderMessages(initialLoad: true, force: true, silent: true));
  }

  void setChatVisibility(bool visible, {Object? owner}) {
    if (owner != null) {
      if (!visible && _visibleOwner != null && _visibleOwner != owner) return;
      _visibleOwner = owner;
    }
    final becameVisible = visible && !_chatVisible;
    _chatVisible = visible;
    final selected = state.selectedChat;
    if (isClosed || !visible || selected == null) return;
    final peer = _identity(selected);
    if (selected.unreadCount(currentUserId, currentUserType) > 0) {
      _readRevisions[peer.key] = ++_revision;
      _put(selected.copyWith(
          messages:
              selected.messages?.map((m) => m.copyWith(viewed: true)).toList(),
          unViewedMessagesCount: 0));
      unawaited(markChatViewed(peer.id, peer.type));
    }
    if (becameVisible) _refreshVisibleHistory();
  }

  int get currentUserId => _cachedUserId;
  int get currentUserType => _cachedUserType;
  bool get hasLoadedConversationSummaries => _messagesLoaded;
  int get totalUnreadCount =>
      state.calculateTotalUnread(currentUserId, currentUserType);
  bool _valid(int session) => !isClosed && session == _session;
  ChatIdentity _identity(GetAllMessagesModel chat) =>
      ChatIdentity(chat.touser ?? 0, chat.tousertype ?? 0);
  ChatIdentity _resolve(ChatIdentity peer) => _assignedPeers[peer.key] ?? peer;
  GetAllMessagesModel? _find(ChatIdentity peer) {
    for (final chat in state.allMessages) {
      if (peer.matches(chat.touser ?? -1, chat.tousertype ?? -1)) return chat;
    }
    final selected = state.selectedChat;
    return selected != null && peer.key == _identity(selected).key
        ? selected
        : null;
  }

  bool get selectedChatIsClosed {
    final chat = state.selectedChat;
    return chat != null &&
        (_closedChats[_identity(chat).key] ??
            chat.lastMessage?.isClosed ??
            false);
  }

  void configureUser(int id, int type) {
    if (_cachedUserId == id && _cachedUserType == type) return;
    reset();
    _cachedUserId = id;
    _cachedUserType = type;
  }

  Future<bool> _ensureUser(int session) async {
    if (currentUserId > 0 && currentUserType > 0) return true;
    final user = await AuthLocalStorage.getUser();
    if (!_valid(session) || user?.userid == null || user?.type == null) {
      return false;
    }
    _cachedUserId = user!.userid!;
    _cachedUserType = user.type!;
    return currentUserId > 0 && currentUserType > 0;
  }

  Future<void> init() async {
    final session = _session;
    if (!await _ensureUser(session)) return;
    await Future.wait([
      if (!_messagesLoaded) getAllMessages(),
      if (!_teamLoaded) getWorkTeam(),
    ]);
  }

  Future<void> ensureMessagesLoaded() async {
    if (!_messagesLoaded) await getAllMessages();
  }

  List<ChatMessageModel> _mergeMessages(
      Iterable<ChatMessageModel> existing, Iterable<ChatMessageModel> incoming,
      {bool reconcileLocal = false, bool fromHistory = false}) {
    final result = <ChatMessageModel>[];
    for (final item in existing) {
      if (item.id > 0 && result.any((m) => m.id == item.id)) continue;
      result.add(item);
    }
    for (final message in incoming) {
      if (_deletedMessageIds.contains(message.id)) continue;
      var index =
          result.indexWhere((m) => message.id != 0 && m.id == message.id);
      // Only reconcile an unacknowledged local send. Two server messages with
      // identical text remain distinct. The send response ID takes precedence.
      if ((reconcileLocal || fromHistory) &&
          !_matchedMessageIds.contains(message.id) &&
          message.id > 0 &&
          message.isOutgoing(currentUserId, currentUserType)) {
        final peer = _messagePeer(message);
        final localIndex = result.indexWhere((m) =>
            m.id < 0 &&
            _knownIdsAtSend.containsKey(m.id) &&
            !_knownIdsAtSend[m.id]!.contains(message.id) &&
            m.isOutgoing(currentUserId, currentUserType) &&
            peer?.key == _messagePeer(m)?.key &&
            m.message == message.message &&
            (m.orderId ?? 0) == (message.orderId ?? 0) &&
            (m.harageId ?? 0) == (message.harageId ?? 0) &&
            (!fromHistory ||
                (m.date != null &&
                    message.date != null &&
                    message.date!.difference(m.date!).inMilliseconds.abs() <
                        1000)));
        if (localIndex >= 0) {
          _matchedMessageIds.add(message.id);
          _knownIdsAtSend.remove(result[localIndex].id);
          if (index < 0) {
            index = localIndex;
          } else {
            result.removeAt(localIndex);
            if (localIndex < index) index--;
          }
        }
      }
      if (index < 0) {
        result.add(message);
      } else {
        result[index] = message.copyWith(
            date: message.date ?? result[index].date,
            viewed: message.viewed || result[index].viewed);
      }
    }
    result.sort((a, b) {
      final date =
          (a.date ?? DateTime(1970)).compareTo(b.date ?? DateTime(1970));
      return date != 0 ? date : a.id.compareTo(b.id);
    });
    return result;
  }

  ChatIdentity? _messagePeer(ChatMessageModel message) {
    final peer = ChatIdentity.peer(
      userId: currentUserId,
      userType: currentUserType,
      fromId: message.fromUser,
      fromType: message.fromUserType,
      toId: message.toUser,
      toType: message.toUserType,
    );
    return peer == null ? null : _resolve(peer);
  }

  ChatMessageModel _historyIdentity(
      ChatMessageModel message, ChatIdentity peer) {
    // Roles may be omitted in history, where the request already identifies
    // both endpoints. Do not make this inference for a push or colliding IDs.
    if (currentUserId == peer.id) return message;
    if (message.fromUser == currentUserId &&
        (message.toUser == peer.id ||
            (peer.type == UserType.adminUser && message.toUser == 0))) {
      return message.copyWith(
          fromUserType: message.fromUserType == 0 ? currentUserType : null,
          toUserType: message.toUserType == 0 ? peer.type : null);
    }
    if (message.fromUser == peer.id && message.toUser == currentUserId) {
      return message.copyWith(
          fromUserType: message.fromUserType == 0 ? peer.type : null,
          toUserType: message.toUserType == 0 ? currentUserType : null);
    }
    return message;
  }

  List<GetAllMessagesModel> _applySearch(
      List<GetAllMessagesModel> list, String query) {
    final lower = query.trim().toLowerCase();
    if (lower.isEmpty) return list;
    return list
        .where((chat) =>
            (chat.userName ?? '').toLowerCase().contains(lower) ||
            (chat.lastMessage?.message ?? '').toLowerCase().contains(lower))
        .toList();
  }

  void _publish(List<GetAllMessagesModel> chats,
      {GetAllMessagesModel? selected,
      bool clearSelected = false,
      bool supportRemoved = false}) {
    chats.sort((a, b) => (b.lastMessage?.date ?? DateTime(1970))
        .compareTo(a.lastMessage?.date ?? DateTime(1970)));
    final active = clearSelected
        ? null
        : selected ??
            (state.selectedChat == null
                ? null
                : chats
                    .where((c) =>
                        _identity(c).key == _identity(state.selectedChat!).key)
                    .firstOrNull) ??
            state.selectedChat;
    emit(state.copyWith(
      allMessages: chats,
      filteredMessages: _applySearch(chats, state.searchQuery),
      selectedChat: active,
      clearSelectedChat: clearSelected,
      closedSelectedChatRevision:
          state.closedSelectedChatRevision + (supportRemoved ? 1 : 0),
      chatClosed: active != null &&
          (_closedChats[_identity(active).key] ??
              active.lastMessage?.isClosed ??
              false),
      isLoadingOlder: active != null &&
          _loadingThreads[_loadingKey(_identity(active))] == true,
    ));
  }

  void _put(GetAllMessagesModel chat) {
    final chats = state.allMessages
        .where((c) => _identity(c).key != _identity(chat).key)
        .toList()
      ..add(chat);
    _publish(chats);
  }

  Future<void> getAllMessages() {
    if (_summaryRequest != null) return _summaryRequest!;
    final request = _loadAllMessages();
    _summaryRequest = request;
    return request.whenComplete(() {
      if (identical(_summaryRequest, request)) _summaryRequest = null;
    });
  }

  Future<void> _loadAllMessages() async {
    if (isClosed || state.isLoadingMessages) return;
    final session = _session;
    final revision = _revision;
    emit(state.copyWith(isLoadingMessages: true, clearErrorMessage: true));
    try {
      if (!await _ensureUser(session)) return;
      final fetched = await chatRepository.getAllMessages(
          userId: currentUserId, userType: currentUserType);
      if (!_valid(session)) return;
      final chats = <String, GetAllMessagesModel>{};
      for (final item in fetched) {
        final peer = _resolve(_identity(item));
        if (peer.type == UserType.adminUser) {
          if (_ignoreRemoteSupport || _closedChats[peer.key] == true) continue;
          if (item.isClosed == true || item.lastMessage?.isClosed == true) {
            _closedChats[peer.key] = true;
            _deletedMessageIds.addAll(
                (item.messages ?? []).where((m) => m.id > 0).map((m) => m.id));
            if (_find(peer) != null) _deleteSupport(peer);
            continue;
          }
        }
        final previous = chats[peer.key];
        chats[peer.key] = item.copyWith(
            touser: peer.id,
            messages: _mergeMessages(previous?.messages ?? [],
                (item.messages ?? []).map((m) => _historyIdentity(m, peer)),
                fromHistory: true));
      }
      // Merge the current state after await: pushes, sends, read state and
      // assignment changes that happened during the request must survive.
      for (final local in state.allMessages) {
        final peer = _resolve(_identity(local));
        final remote = chats[peer.key];
        final remoteIds = remote?.messages?.map((m) => m.id).toSet() ?? <int>{};
        final newUnread = (local.messages ?? [])
            .where((m) =>
                (_arrivalRevisions[m.id] ?? 0) > revision &&
                !m.viewed &&
                !m.isOutgoing(currentUserId, currentUserType) &&
                !remoteIds.contains(m.id))
            .length;
        final localCount = local.unreadCount(currentUserId, currentUserType);
        final remoteCount =
            (remote?.unreadCount(currentUserId, currentUserType) ?? 0) +
                newUnread;
        final readRevision = _readRevisions[peer.key] ?? 0;
        final readAfterRequest = readRevision > revision;
        final active = _chatVisible &&
            state.selectedChat != null &&
            _identity(state.selectedChat!).key == peer.key;
        final unread = active
            ? 0
            : readAfterRequest || remote == null
                ? localCount
                : (localCount > remoteCount ? localCount : remoteCount);
        final remoteMessages = (remote?.messages ?? []).map((message) {
          if (!readAfterRequest) return message;
          final arrivedAfterRead =
              (_arrivalRevisions[message.id] ?? 0) > readRevision;
          return message.copyWith(viewed: !arrivedAfterRead);
        });
        final messages = _mergeMessages(local.messages ?? [], remoteMessages,
            fromHistory: true);
        chats[peer.key] = local.copyWith(
            touser: peer.id,
            unViewedMessagesCount: unread,
            messages: active
                ? messages.map((m) => m.copyWith(viewed: true)).toList()
                : messages);
        if (active &&
            (remote?.unreadCount(currentUserId, currentUserType) ?? 0) > 0) {
          unawaited(markChatViewed(peer.id, peer.type));
        }
      }
      _messagesLoaded = true;
      _publish(chats.values.toList());
    } catch (e) {
      if (_valid(session)) {
        emit(state.copyWith(
            errorMessage: e.toString().replaceFirst('Exception: ', '')));
      }
    } finally {
      if (_valid(session)) emit(state.copyWith(isLoadingMessages: false));
    }
  }

  Future<void> getWorkTeam() async {
    if (isClosed || state.isLoadingWorkTeam) return;
    final session = _session;
    emit(state.copyWith(isLoadingWorkTeam: true, clearErrorMessage: true));
    try {
      if (!await _ensureUser(session)) return;
      final team = await chatRepository.getWorkTeam(
          userId: currentUserId, userType: currentUserType);
      if (!_valid(session)) return;
      _teamLoaded = true;
      emit(state.copyWith(workTeam: [
        WorkTeamMemberModel(
            userid: 0,
            usertype: UserType.adminUser,
            name: 'الدعم الفني',
            latinname: 'Technical Support',
            jobname: 'إدارة النظام',
            latinjobname: 'System Management'),
        ...team.where((m) => m.usertype != UserType.adminUser),
      ]));
    } catch (e) {
      if (_valid(session)) {
        emit(state.copyWith(
            errorMessage: e.toString().replaceFirst('Exception: ', '')));
      }
    } finally {
      if (_valid(session)) emit(state.copyWith(isLoadingWorkTeam: false));
    }
  }

  GetAllMessagesModel supportChat() {
    final existing = state.allMessages
        .where((chat) =>
            chat.tousertype == UserType.adminUser &&
            _closedChats[_identity(chat).key] != true &&
            chat.isClosed != true)
        .firstOrNull;
    if (existing != null) return existing;
    // A genuinely new support ticket has no history to load. Pair-based history
    // can otherwise bring a previous ticket back into the new conversation.
    _ignoreRemoteSupport = true;
    if (_closedChats.values.any((closed) => closed)) {
      _ignoreRemoteSupport = true;
      _closedChats['0:${UserType.adminUser}'] = true;
    }
    return GetAllMessagesModel(
        touser: 0,
        tousertype: UserType.adminUser,
        userName: 'الدعم الفني',
        messages: []);
  }

  void selectChat(GetAllMessagesModel chat) {
    if (isClosed || currentUserId <= 0 || currentUserType <= 0) return;
    var peer = _resolve(_identity(chat));
    if (peer.type == UserType.adminUser) {
      if (chat.touser == 0 &&
          _find(const ChatIdentity(0, UserType.adminUser)) == null &&
          _closedChats['0:${UserType.adminUser}'] == true) {
        peer = const ChatIdentity(0, UserType.adminUser);
        _assignedPeers.remove(peer.key);
        _closedChats.remove(peer.key);
        _supportEpochs[peer.key] = ++_nextSupportEpoch;
      }
      if (_closedChats[peer.key] == true ||
          chat.isClosed == true ||
          chat.lastMessage?.isClosed == true) {
        return;
      }
      _supportEpochs.putIfAbsent(peer.key, () => ++_nextSupportEpoch);
      if (_ignoreRemoteSupport) _loadedThreads.add(peer.key);
    }
    final opening = state.selectedChat == null ||
        _identity(state.selectedChat!).key != peer.key;
    chat = _find(peer) ?? chat.copyWith(touser: peer.id);
    if (_ignoreRemoteSupport && peer.type == UserType.adminUser) {
      chat = chat.copyWith(noOldMessages: true);
    }
    _chatVisible = true;
    _readRevisions[peer.key] = ++_revision;
    final unread = chat.unreadCount(currentUserId, currentUserType);
    final readChat = chat.copyWith(
      messages: _mergeMessages([], chat.messages ?? [])
          .map((m) => m.copyWith(viewed: true))
          .toList(),
      unViewedMessagesCount: 0,
    );
    ChatEvents.instance.activeChatUserId = peer.id;
    ChatEvents.instance.activeChatUserType = peer.type;
    _publish(
        state.allMessages.where((c) => _identity(c).key != peer.key).toList()
          ..add(readChat),
        selected: readChat);
    if (opening) {
      emit(state.copyWith(
          selectedConversationRevision:
              state.selectedConversationRevision + 1));
    }
    if (unread > 0) unawaited(markChatViewed(peer.id, peer.type));
    // History is loaded on opening, regardless of the summary's message count.
    unawaited(getOlderMessages(initialLoad: true));
  }

  void clearSelectedChat({Object? owner}) {
    if (isClosed) return;
    if (owner != null && _visibleOwner != owner) return;
    _visibleOwner = null;
    ChatEvents.instance.activeChatUserId = null;
    ChatEvents.instance.activeChatUserType = null;
    _chatVisible = false;
    emit(state.copyWith(
        clearSelectedChat: true, chatClosed: false, isLoadingOlder: false));
  }

  void selectTab(int index) {
    if (!isClosed) emit(state.copyWith(selectedTab: index));
  }

  void searchMessages(String query) {
    if (!isClosed) {
      emit(state.copyWith(
          searchQuery: query,
          filteredMessages: _applySearch(state.allMessages, query)));
    }
  }

  void _adoptSupportPeer(ChatIdentity peer, {bool accepted = false}) {
    if (peer.type != UserType.adminUser || peer.id <= 0) return;
    const pending = ChatIdentity(0, UserType.adminUser);
    final unassigned = _find(pending);
    if (unassigned == null && !accepted) return;
    final assigned = _find(peer);
    final epoch = unassigned != null
        ? _epoch(pending)
        : _supportEpochs[peer.key] ?? ++_nextSupportEpoch;
    _supportEpochs[peer.key] = epoch;
    _supportEpochs[pending.key] = epoch;
    _assignedPeers[pending.key] = peer;
    _closedChats.remove(peer.key);
    final combined = (assigned ??
            unassigned ??
            GetAllMessagesModel(
                touser: peer.id,
                tousertype: peer.type,
                userName: 'الدعم الفني',
                messages: []))
        .copyWith(
            touser: peer.id,
            messages: _mergeMessages(
                unassigned?.messages ?? [], assigned?.messages ?? []),
            unViewedMessagesCount:
                (unassigned?.unreadCount(currentUserId, currentUserType) ?? 0) +
                    (assigned?.unreadCount(currentUserId, currentUserType) ??
                        0));
    if (_closedChats.containsKey(pending.key) &&
        !_closedChats.containsKey(peer.key)) {
      _closedChats[peer.key] = _closedChats[pending.key]!;
    }
    if (_loadedThreads.remove(pending.key)) _loadedThreads.add(peer.key);
    final selectedPending = state.selectedChat != null &&
        _identity(state.selectedChat!).key == pending.key;
    if (selectedPending) {
      ChatEvents.instance.activeChatUserId = peer.id;
      ChatEvents.instance.activeChatUserType = peer.type;
    }
    _publish(
        state.allMessages
            .where((c) =>
                _identity(c).key != pending.key && _identity(c).key != peer.key)
            .toList()
          ..add(combined),
        selected: selectedPending ? combined : null);
  }

  bool applyChatStatus(Map<String, dynamic> data) =>
      applyChatStatusPayload(NotificationPayload(data));

  bool applyChatStatusPayload(NotificationPayload payload) {
    if (isClosed ||
        payload.kind != NotificationKind.chatStatus ||
        !payload.isDirectChat) {
      return false;
    }
    final rawPeer = payload.chatPeer(currentUserId, currentUserType);
    final closed = NotificationPayload.boolean(payload.get('isclosed'));
    if (rawPeer == null ||
        rawPeer.type != UserType.adminUser ||
        closed == null) {
      return false;
    }
    final peer = _resolve(rawPeer);
    final previousEpoch = _statusEpochs[payload.key];
    if (payload.messageId?.isNotEmpty == true &&
        previousEpoch != null &&
        previousEpoch != _epoch(peer)) {
      return false;
    }
    if (!closed &&
        _closedChats[peer.key] == true &&
        _find(const ChatIdentity(0, UserType.adminUser)) == null) {
      return false;
    }
    if (closed) {
      _statusEpochs[payload.key] = _epoch(peer);
      _deleteSupport(peer);
    } else {
      if (peer.id > 0) _adoptSupportPeer(peer, accepted: true);
      _closedChats[peer.key] = false;
      _statusEpochs[payload.key] = _epoch(peer);
      emit(state.copyWith(chatClosed: false));
    }
    return true;
  }

  void _deleteSupport(ChatIdentity peer) {
    const pending = ChatIdentity(0, UserType.adminUser);
    final keys = {peer.key};
    if (peer.id == 0 || _assignedPeers[pending.key]?.key == peer.key) {
      keys.add(pending.key);
    }
    for (final chat
        in state.allMessages.where((c) => keys.contains(_identity(c).key))) {
      _deletedMessageIds.addAll(
          (chat.messages ?? []).where((m) => m.id > 0).map((m) => m.id));
      for (final m in chat.messages ?? <ChatMessageModel>[]) {
        _knownIdsAtSend.remove(m.id);
      }
    }
    _ignoreRemoteSupport = true;
    for (final key in keys) {
      _closedChats[key] = true;
      _supportEpochs[key] = ++_nextSupportEpoch;
      _loadedThreads.remove(key);
      _loadingThreads.remove(key);
      _pendingHistoryRefreshes.remove(key);
      _readTimers.remove(key)?.cancel();
    }
    if (keys.contains(_assignedPeers[pending.key]?.key)) {
      _assignedPeers.remove(pending.key);
    }
    // Starting the next ticket must never resolve its recipient back to the old admin.
    if (keys.contains(pending.key) || _find(pending) == null) {
      _closedChats[pending.key] = true;
      _supportEpochs[pending.key] = ++_nextSupportEpoch;
    }
    if (_sendingPeer != null && keys.contains(_resolve(_sendingPeer!).key)) {
      _sendSerial++;
      _sendingPeer = null;
      emit(state.copyWith(isSendingMessage: false));
    }
    final selectedRemoved = state.selectedChat != null &&
        keys.contains(_identity(state.selectedChat!).key);
    if (selectedRemoved) {
      _chatVisible = false;
      ChatEvents.instance.activeChatUserId = null;
      ChatEvents.instance.activeChatUserType = null;
    }
    _publish(
        state.allMessages
            .where((c) => !keys.contains(_identity(c).key))
            .toList(),
        clearSelected: selectedRemoved,
        supportRemoved: selectedRemoved);
  }

  /// Orders open the ordinary peer conversation, without creating an order thread.
  Future<bool> openContactChat(
      {required int userId,
      required int userType,
      String? name,
      Uint8List? image}) async {
    final session = _session;
    if (isClosed ||
        !await _ensureUser(session) ||
        !_valid(session) ||
        currentUserType != UserType.providerUser ||
        userId <= 0 ||
        userType <= 0 ||
        userType >= UserType.adminUser ||
        (userId == currentUserId && userType == currentUserType)) return false;
    final peer = ChatIdentity(userId, userType);
    selectChat(_find(peer) ??
        GetAllMessagesModel(
            touser: userId,
            tousertype: userType,
            userName: name,
            image: image));
    return state.selectedChat != null &&
        _identity(state.selectedChat!).key == peer.key;
  }

  bool selectNotificationChat(NotificationPayload payload) {
    if (isClosed ||
        (payload.integer('harageId') ?? 0) != 0 ||
        (payload.kind != NotificationKind.chat &&
            payload.kind != NotificationKind.chatStatus)) {
      return false;
    }
    final rawPeer = payload.chatPeer(currentUserId, currentUserType);
    if (rawPeer == null) return false;
    if (rawPeer.type == UserType.adminUser && !payload.isDirectChat) {
      return false;
    }
    if (_deletedMessageIds.contains(payload.integer('id'))) return false;
    if (payload.kind == NotificationKind.chatStatus &&
        (rawPeer.type != UserType.adminUser ||
            NotificationPayload.boolean(payload.get('isclosed')) == null)) {
      return false;
    }
    if (payload.kind == NotificationKind.chatStatus &&
        NotificationPayload.boolean(payload.get('isclosed')) == true) {
      return false;
    }
    final knownEpoch = _statusEpochs[payload.key];
    if ((knownEpoch != null && knownEpoch != _epoch(_resolve(rawPeer))) ||
        _closedChats[_resolve(rawPeer).key] == true) {
      return false;
    }
    if (payload.kind == NotificationKind.chatStatus &&
        !_closedChats.containsKey(_resolve(rawPeer).key)) {
      applyChatStatusPayload(payload);
    }
    final peer = _resolve(rawPeer);
    selectChat(_find(peer) ??
        GetAllMessagesModel(
            touser: peer.id,
            tousertype: peer.type,
            userName: peer.type == UserType.adminUser
                ? 'الدعم الفني'
                : payload.get('fromusername')?.toString()));
    return true;
  }

  Future<void> sendMessage(String text, {int? orderId}) async {
    final trimmed = text.trim();
    final chat = state.selectedChat;
    if (isClosed ||
        trimmed.isEmpty ||
        chat == null ||
        selectedChatIsClosed ||
        state.isSendingMessage ||
        currentUserId <= 0 ||
        currentUserType <= 0 ||
        chat.touser == null ||
        (chat.touser == 0 && chat.tousertype != UserType.adminUser) ||
        (chat.tousertype ?? 0) <= 0) {
      return;
    }
    final session = _session;
    final targetPeer = _identity(chat);
    final epoch = _epoch(targetPeer);
    final serial = ++_sendSerial;
    _sendingPeer = targetPeer;
    final outgoing = ChatMessageModel(
        id: --_localId,
        fromUser: currentUserId,
        fromUserType: currentUserType,
        toUser: chat.touser!,
        toUserType: chat.tousertype!,
        message: trimmed,
        date: _now().toUtc(),
        viewed: true,
        orderId: orderId);
    _knownIdsAtSend[outgoing.id] =
        (chat.messages ?? []).where((m) => m.id > 0).map((m) => m.id).toSet();
    _put(chat.copyWith(
        messages: _mergeMessages(chat.messages ?? [], [outgoing])));
    emit(state.copyWith(isSendingMessage: true, clearErrorMessage: true));
    try {
      final response = await chatRepository.sendChatMessage(
          message: SendChatMessageModel(
              fromUser: currentUserId,
              fromUserType: currentUserType,
              toUser: outgoing.toUser,
              toUserType: outgoing.toUserType,
              date: outgoing.date,
              orderId: orderId ?? 0,
              message: trimmed));
      final root = NotificationPayload.object(response);
      if (response == false ||
          NotificationPayload.value(root, 'status') == false ||
          NotificationPayload.value(root, 'success') == false) {
        throw StateError(
            '${NotificationPayload.value(root, 'message') ?? 'Failed to send message'}');
      }
      final nested =
          NotificationPayload.object(NotificationPayload.value(root, 'data'));
      final result = nested.isNotEmpty ? nested : root;
      final returned = NotificationPayload(result);
      final returnedId = returned.integer('id');
      final returnedDate = ChatMessageModel.parseDate(returned.get('date'));
      // A generic success envelope may also have an ID. Only a message-shaped
      // response for this exact send can acknowledge the local message.
      final rawPeer = returned.chatPeer(currentUserId, currentUserType);
      final matchesSend = returnedId != null &&
          returnedId > 0 &&
          returnedDate != null &&
          returned.contextId('orderId') == (outgoing.orderId ?? 0) &&
          returned.contextId('harageId') == 0 &&
          returned.integer('fromuser') == outgoing.fromUser &&
          returned.integer('fromusertype') == outgoing.fromUserType &&
          rawPeer != null &&
          _resolve(rawPeer).key == _messagePeer(outgoing)?.key &&
          returned.get('message') == outgoing.message;
      if (!_requestValid(session, targetPeer, epoch) || serial != _sendSerial) {
        if (_valid(session) &&
            targetPeer.type == UserType.adminUser &&
            matchesSend) {
          _deletedMessageIds.add(returnedId);
        }
        return;
      }
      if (matchesSend) {
        _knownIdsAtSend.remove(outgoing.id);
        _matchedMessageIds.add(returnedId);
        final peer = _messagePeer(outgoing)!;
        final latest = _find(peer);
        if (latest != null) {
          final existing =
              latest.messages?.where((m) => m.id == returnedId).firstOrNull;
          // An earlier echo already has the backend timestamp and canonical data.
          final acknowledged =
              existing ?? outgoing.copyWith(id: returnedId, date: returnedDate);
          final messages = latest.messages?.where((m) => m.id != outgoing.id) ??
              <ChatMessageModel>[];
          _put(latest.copyWith(
              messages: _mergeMessages(messages, [acknowledged])));
        }
      }
    } catch (e) {
      if (!_requestValid(session, targetPeer, epoch) || serial != _sendSerial) {
        return;
      }
      _knownIdsAtSend.remove(outgoing.id);
      final latest = _find(_messagePeer(outgoing)!);
      if (latest != null) {
        _put(latest.copyWith(
            messages:
                latest.messages?.where((m) => m.id != outgoing.id).toList()));
      }
      emit(state.copyWith(
          errorMessage: e.toString().replaceFirst('Exception: ', '')));
    } finally {
      if (_requestValid(session, targetPeer, epoch) && serial == _sendSerial) {
        _sendingPeer = null;
        emit(state.copyWith(isSendingMessage: false));
      }
    }
  }

  Future<void> reloadSelectedChat() =>
      getOlderMessages(initialLoad: true, force: true);

  Future<void> getOlderMessages({
    bool initialLoad = false,
    bool force = false,
    bool silent = false,
  }) async {
    final chat = state.selectedChat;
    if (isClosed ||
        chat == null ||
        currentUserId <= 0 ||
        currentUserType <= 0) {
      return;
    }
    final peer = _identity(chat);
    if (peer.type == UserType.adminUser && _ignoreRemoteSupport) return;
    if (_loadingKey(peer) != null ||
        (initialLoad && !force && _loadedThreads.contains(peer.key)) ||
        (!initialLoad && chat.noOldMessages)) {
      return;
    }
    final session = _session;
    final epoch = _epoch(peer);
    _loadingThreads[peer.key] = !silent;
    if (!silent) {
      emit(state.copyWith(isLoadingOlder: true, clearErrorMessage: true));
    }
    try {
      final fetched = initialLoad
          ? await chatRepository.getChatMessages(
              fromUserId: currentUserId,
              fromUserType: currentUserType,
              toUserId: peer.id,
              toUserType: peer.type)
          : await chatRepository.getOlderMessages(
              fromUser: currentUserId,
              fromUserType: currentUserType,
              toUser: peer.id,
              toUserType: peer.type,
              date: (chat.messages?.firstOrNull?.date ??
                      _now().add(const Duration(days: 1)))
                  .toUtc()
                  .toIso8601String());
      if (!_requestValid(session, peer, epoch)) return;
      final resolved = _resolve(peer);
      final latest = _find(resolved) ?? chat.copyWith(touser: resolved.id);
      final active = _chatVisible &&
          state.selectedChat != null &&
          _identity(state.selectedChat!).key == resolved.key;
      final messages = _mergeMessages(latest.messages ?? [],
          fetched.map((m) => _historyIdentity(m, resolved)),
          fromHistory: true);
      _loadedThreads.add(resolved.key);
      final knownUnread = messages
          .where(
              (m) => !m.viewed && !m.isOutgoing(currentUserId, currentUserType))
          .length;
      final existingUnread = latest.unreadCount(currentUserId, currentUserType);
      _put(latest.copyWith(
          messages: active
              ? messages.map((m) => m.copyWith(viewed: true)).toList()
              : messages,
          unViewedMessagesCount: active
              ? 0
              : (knownUnread > existingUnread ? knownUnread : existingUnread),
          noOldMessages: fetched.length < 10));
      if (active &&
          fetched.any((m) =>
              !m.viewed && !m.isOutgoing(currentUserId, currentUserType))) {
        unawaited(markChatViewed(resolved.id, resolved.type));
      }
    } catch (e) {
      if (!silent && _requestValid(session, peer, epoch)) {
        emit(state.copyWith(
            errorMessage: e.toString().replaceFirst('Exception: ', '')));
      }
    } finally {
      if (_requestValid(session, peer, epoch)) {
        _loadingThreads.remove(peer.key);
        if (!silent) _publish(List.of(state.allMessages));
        if (_pendingHistoryRefreshes.remove(peer.key) &&
            state.selectedChat != null &&
            _identity(state.selectedChat!).key == _resolve(peer).key) {
          _refreshVisibleHistory();
        }
      }
    }
  }

  Future<void> markChatViewed(int toUser, int toUserType) async {
    if (isClosed || currentUserId <= 0 || currentUserType <= 0) return;
    final session = _session;
    final peer = ChatIdentity(toUser, toUserType);
    final epoch = _epoch(peer);
    try {
      final success = await chatRepository.makeChatViewed(
          fromUser: currentUserId,
          fromUserType: currentUserType,
          toUser: toUser,
          toUserType: toUserType);
      if (!success && _requestValid(session, peer, epoch) &&
          state.selectedChat != null && _identity(state.selectedChat!).key == peer.key) {
        emit(state.copyWith(errorMessage: 'Could not update read status'));
      }
      // Acknowledging reads never reloads history or clears newer unread arrivals.
    } catch (_) {}
  }

  bool acceptsMessagePayload(NotificationPayload payload) {
    if (isClosed ||
        currentUserId <= 0 ||
        payload.kind != NotificationKind.chat ||
        (payload.integer('id') ?? 0) <= 0 ||
        _deletedMessageIds.contains(payload.integer('id')) ||
        ChatMessageModel.parseDate(payload.get('date')) == null ||
        (payload.get('message') == null && payload.body.isEmpty)) {
      return false;
    }
    if (['orderId', 'harageId'].any((key) => payload.contextId(key) == null)) {
      return false;
    }
    if ((payload.integer('harageId') ?? 0) != 0) return false;
    final rawPeer = payload.chatPeer(currentUserId, currentUserType);
    if (rawPeer == null) return false;
    final peer = _resolve(rawPeer);
    if (peer.type == UserType.adminUser) {
      if ((payload.integer('orderId') ?? 0) != 0) return false;
      if (_closedChats[peer.key] == true &&
          _find(const ChatIdentity(0, UserType.adminUser)) == null) {
        return false;
      }
    }
    return true;
  }

  bool onIncomingMessage(ChatMessageModel message) {
    if (isClosed ||
        message.id <= 0 ||
        message.date == null ||
        (message.harageId ?? 0) != 0) {
      return false;
    }
    if (_deletedMessageIds.contains(message.id)) return false;
    var peer = _messagePeer(message);
    if (peer == null ||
        (peer.type == UserType.adminUser && (message.orderId ?? 0) != 0)) {
      return false;
    }
    if (peer.type == UserType.adminUser &&
        _closedChats[peer.key] == true &&
        _find(const ChatIdentity(0, UserType.adminUser)) == null) {
      return false;
    }
    final outgoing = message.isOutgoing(currentUserId, currentUserType);
    if (!outgoing) _adoptSupportPeer(peer);
    peer = _resolve(peer);
    final chat = _find(peer) ??
        GetAllMessagesModel(
            touser: peer.id,
            tousertype: peer.type,
            userName: peer.type == UserType.adminUser
                ? 'الدعم الفني'
                : message.fromUserName,
            messages: []);
    final duplicate = chat.messages?.any((m) => m.id == message.id) ?? false;
    final active = _chatVisible &&
        state.selectedChat != null &&
        _identity(state.selectedChat!).key == peer.key;
    if (!duplicate && !outgoing && !message.viewed) {
      _arrivalRevisions[message.id] = ++_revision;
    }
    _put(chat.copyWith(
        messages: _mergeMessages(chat.messages ?? [],
            [message.copyWith(viewed: active || outgoing || message.viewed)],
            reconcileLocal: true),
        unViewedMessagesCount: active
            ? 0
            : chat.unreadCount(currentUserId, currentUserType) +
                (outgoing || duplicate || message.viewed ? 0 : 1)));
    if (active && !outgoing && !duplicate) {
      final target = peer;
      final session = _session;
      final epoch = _epoch(target);
      _readTimers[target.key]?.cancel();
      _readTimers[target.key] = Timer(const Duration(milliseconds: 500), () {
        _readTimers.remove(target.key);
        if (_requestValid(session, target, epoch) &&
            _chatVisible &&
            state.selectedChat != null &&
            _identity(state.selectedChat!).key == target.key) {
          unawaited(markChatViewed(target.id, target.type));
        }
      });
    }
    return !duplicate;
  }

  void _handleRealtimeChatEvent(ReceiveMessageData event) {
    final payload = NotificationPayload({
      'type': event.type ?? 'chat',
      'id': event.id,
      'fromuser': event.fromUser,
      'fromusertype': event.fromUserType,
      'touser': event.toUser,
      'tousertype': event.toUserType,
      'orderid': event.orderId,
      'harageid': event.harageId,
      'message': event.message,
      'date': event.date,
    });
    if (event.type != null && payload.kind != NotificationKind.chat) return;
    if (!acceptsMessagePayload(payload)) {
      return;
    }
    final id = int.tryParse(event.id ?? '');
    final date = ChatMessageModel.parseDate(event.date);
    if (id == null || id <= 0 || date == null || event.message == null) {
      debugPrint('Chat payload missing message ID, backend date or message');
      return;
    }
    onIncomingMessage(ChatMessageModel(
        id: id,
        fromUser: int.parse(event.fromUser!),
        fromUserType: int.parse(event.fromUserType!),
        toUser: int.parse(event.toUser!),
        toUserType: int.parse(event.toUserType!),
        message: event.message!,
        date: date,
        viewed: NotificationPayload.boolean(event.viewed) ?? false,
        isClosed: NotificationPayload.boolean(event.isClosed) ?? false,
        orderId: int.tryParse(event.orderId ?? ''),
        harageId: int.tryParse(event.harageId ?? ''),
        fromUserName: event.fromUserName));
  }

  void reset() {
    _session++;
    _cachedUserId = _cachedUserType = _localId = 0;
    _messagesLoaded = _teamLoaded = false;
    _summaryRequest = null;
    _closedChats.clear();
    _loadedThreads.clear();
    _loadingThreads.clear();
    _pendingHistoryRefreshes.clear();
    _assignedPeers.clear();
    _supportEpochs.clear();
    _statusEpochs.clear();
    _readRevisions.clear();
    _arrivalRevisions.clear();
    _knownIdsAtSend.clear();
    _matchedMessageIds.clear();
    _deletedMessageIds.clear();
    _nextSupportEpoch = _revision = 0;
    _sendSerial++;
    _sendingPeer = null;
    _ignoreRemoteSupport = false;
    _chatVisible = true;
    _visibleOwner = null;
    for (final timer in _readTimers.values) {
      timer.cancel();
    }
    _readTimers.clear();
    ChatEvents.instance.activeChatUserId = null;
    ChatEvents.instance.activeChatUserType = null;
    if (!isClosed) emit(const ProviderChatState());
  }

  @override
  Future<void> close() {
    for (final timer in _readTimers.values) {
      timer.cancel();
    }
    _chatEventsSub?.cancel();
    return super.close();
  }
}
