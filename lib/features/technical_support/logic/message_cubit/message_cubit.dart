import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api_functions/chat/get_user_chats_model/get_user_chats_repository.dart';
import '../../../../core/api_functions/chat/get_user_chats_model/get_user_chats_request.dart';
import '../../../auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../features/technical_support/logic/message_cubit/message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Future<void> getMessages() async {
    emit(MessageLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      final messages = await getUserMessagesFunction(
        request: GetUserChatsRequest(
          userId: user?.userid??5,
          userType: user?.type ??4,
        ),
      );

      emit(MessageSuccess(messages));

    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }
}