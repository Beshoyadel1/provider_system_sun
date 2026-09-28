import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theming/auth_local_storage.dart';
import '../../../../../features/technical_support/data/datasource/get_user_chats_datasource/get_user_chats_repository.dart';
import '../../../../../features/technical_support/data/model/chat_events/chat_events.dart';
import '../../../../../features/technical_support/data/request/get_user_chats_request/get_user_chats_request.dart';
import '../../../../../features/technical_support/presentation/bloc/message_cubit/message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  StreamSubscription? _chatSubscription;

  MessageCubit() : super(MessageInitial()) {
    _chatSubscription = ChatEvents.instance.stream.listen((_) {
      getMessages(showLoading: false);
    });
  }

  Future<void> getMessages({bool showLoading = true}) async {
    if (showLoading) {
      emit(MessageLoading());
    }

    try {
      final user = await AuthLocalStorage.getUser();

      final messages = await getUserMessagesFunction(
        request: GetUserChatsRequest(
          userId: user?.userid ?? 5,
          userType: user?.type ?? 4,
        ),
      );

      emit(MessageSuccess(messages));

    } catch (e) {
      if (showLoading || state is! MessageSuccess) {
        emit(MessageError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}