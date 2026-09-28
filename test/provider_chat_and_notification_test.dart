import 'package:flutter_test/flutter_test.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/features/technical_support/data/model/provider_chat_model.dart';
import 'package:sun_web_system/features/technical_support/presentation/bloc/provider_chat_cubit/provider_chat_cubit.dart';
import 'package:sun_web_system/features/technical_support/data/datasource/provider_chat_repository.dart';

class FakeChatRepository extends ProviderChatRepository {
  const FakeChatRepository();
}

void main() {
  group('Provider Chat Models Tests', () {
    test('GetAllMessagesModel deserializes correctly and computes unread count', () {
      final json = {
        'TOUSER': 10,
        'TOUSERTYPE': 1, // Client
        'USERNAME': 'عميل تجريبي',
        'noOldMessages': false,
        'MESSAGES': [
          {
            'id': 101,
            'FROMUSER': 10,
            'TOUSER': 5,
            'FROMUSERTYPE': 1,
            'TOUSERTYPE': 4,
            'MESSAGE': 'السلام عليكم، هل الطلب جاهز؟',
            'DATE': '2026-09-28T08:30:00Z',
            'viewed': false,
          },
          {
            'id': 102,
            'FROMUSER': 5,
            'TOUSER': 10,
            'FROMUSERTYPE': 4,
            'TOUSERTYPE': 1,
            'MESSAGE': 'أهلاً بك، الطلب قيد التجهيز.',
            'DATE': '2026-09-28T08:35:00Z',
            'viewed': true,
          }
        ]
      };

      final chat = GetAllMessagesModel.fromJson(json);
      expect(chat.touser, equals(10));
      expect(chat.tousertype, equals(1));
      expect(chat.userName, equals('عميل تجريبي'));
      expect(chat.messages?.length, equals(2));

      // Provider user id is 5, type is 4. Message from user 10 (not viewed) should count as 1 unread.
      final unread = chat.unreadCount(5, UserType.providerUser);
      expect(unread, equals(1));
    });

    test('WorkTeamMemberModel localized name and job name helper works properly', () {
      final member = WorkTeamMemberModel(
        userid: 1,
        usertype: UserType.adminUser,
        name: 'الدعم الفني للإدارة',
        latinname: 'System Support',
        jobname: 'الإدارة',
        latinjobname: 'Management',
      );

      expect(member.getLocalizedName('ar'), equals('الدعم الفني للإدارة'));
      expect(member.getLocalizedName('en'), equals('System Support'));
      expect(member.getLocalizedJobName('ar'), equals('الإدارة'));
      expect(member.getLocalizedJobName('en'), equals('Management'));
    });
  });

  group('ProviderChatCubit & State Tests', () {
    late ProviderChatCubit cubit;

    setUp(() {
      cubit = ProviderChatCubit(chatRepository: const FakeChatRepository());
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is correct', () {
      expect(cubit.state.allMessages, isEmpty);
      expect(cubit.state.filteredMessages, isEmpty);
      expect(cubit.state.workTeam, isEmpty);
      expect(cubit.state.selectedChat, isNull);
      expect(cubit.state.selectedTab, equals(0));
    });

    test('selectTab switches tab correctly', () {
      cubit.selectTab(1);
      expect(cubit.state.selectedTab, equals(1));
      cubit.selectTab(0);
      expect(cubit.state.selectedTab, equals(0));
    });

    test('Search filter filters conversations by username and message content', () {
      final chat1 = GetAllMessagesModel(
        touser: 1,
        tousertype: 1,
        userName: 'أحمد علي',
        messages: [
          ChatMessageModel(
            id: 1,
            fromUser: 1,
            toUser: 5,
            fromUserType: 1,
            toUserType: UserType.providerUser,
            message: 'استفسار بخصوص قطع الغيار',
            date: DateTime.now(),
          )
        ],
      );

      final chat2 = GetAllMessagesModel(
        touser: 2,
        tousertype: 1,
        userName: 'خالد محمد',
        messages: [
          ChatMessageModel(
            id: 2,
            fromUser: 2,
            toUser: 5,
            fromUserType: 1,
            toUserType: UserType.providerUser,
            message: 'موعد الصيانة غدا',
            date: DateTime.now(),
          )
        ],
      );

      cubit.emit(cubit.state.copyWith(
        allMessages: [chat1, chat2],
        filteredMessages: [chat1, chat2],
      ));

      // Search by user name
      cubit.searchMessages('أحمد');
      expect(cubit.state.filteredMessages.length, equals(1));
      expect(cubit.state.filteredMessages.first.userName, equals('أحمد علي'));

      // Search by message content
      cubit.searchMessages('الصيانة');
      expect(cubit.state.filteredMessages.length, equals(1));
      expect(cubit.state.filteredMessages.first.userName, equals('خالد محمد'));

      // Search clear
      cubit.searchMessages('');
      expect(cubit.state.filteredMessages.length, equals(2));
    });

    test('Incoming message creates or updates chat conversation', () {
      final incoming = ChatMessageModel(
        id: 999,
        fromUser: 15,
        toUser: 5,
        fromUserType: 1,
        toUserType: UserType.providerUser,
        message: 'رسالة جديدة من العميل',
        date: DateTime.now(),
        fromUserName: 'زبون جديد',
        viewed: false,
      );

      cubit.onIncomingMessage(incoming);

      expect(cubit.state.allMessages.length, equals(1));
      final chat = cubit.state.allMessages.first;
      expect(chat.touser, equals(15));
      expect(chat.userName, equals('زبون جديد'));
      expect(chat.messages?.first.message, equals('رسالة جديدة من العميل'));
      expect(chat.unViewedMessagesCount, equals(1));
    });

    test('SendChatMessageModel.toJson includes uppercase and lowercase keys matching ChatsModel.cs', () {
      final sendModel = SendChatMessageModel(
        fromUser: 5,
        fromUserType: UserType.providerUser,
        toUser: 10,
        toUserType: 1,
        orderId: 100,
        message: 'تم شحن الطلب',
      );

      final json = sendModel.toJson();
      expect(json['FROMUSER'], equals(5));
      expect(json['fromuser'], equals(5));
      expect(json['TOUSER'], equals(10));
      expect(json['touser'], equals(10));
      expect(json['FROMUSERTYPE'], equals(UserType.providerUser));
      expect(json['ORDERID'], equals(100));
      expect(json['MESSAGE'], equals('تم شحن الطلب'));
      expect(json['VIEWED'], equals(false));
      expect(json['ISCLOSED'], equals(false));
    });

    test('GetChatMessages API response structure deserializes messages correctly', () {
      final apiResponse = {
        'data': [
          {
            'TOUSER': 10,
            'TOUSERTYPE': 1,
            'UserName': 'عميل تجريبي',
            'Image': null,
            'Messages': [
              {
                'ID': 501,
                'FROMUSER': 10,
                'TOUSER': 5,
                'MESSAGE': 'السلام عليكم',
                'DATE': '2026-09-28T09:15:00Z',
                'VIEWED': true,
                'ISCLOSED': false,
                'FROMUSERTYPE': 1,
                'TOUSERTYPE': 4,
                'HARAGEID': 0,
                'ORDERID': 0,
                'FROMUSERNAME': 'عميل تجريبي'
              }
            ]
          }
        ]
      };

      final dataList = apiResponse['data'] as List;
      final firstItem = dataList.first as Map<String, dynamic>;
      final rawMessages = firstItem['Messages'] as List;
      final parsedList = rawMessages
          .map((m) => ChatMessageModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();

      expect(parsedList.length, equals(1));
      final msg = parsedList.first;
      expect(msg.id, equals(501));
      expect(msg.fromUser, equals(10));
      expect(msg.toUser, equals(5));
      expect(msg.message, equals('السلام عليكم'));
      expect(msg.fromUserName, equals('عميل تجريبي'));
      expect(msg.viewed, equals(true));
    });
  });
}
