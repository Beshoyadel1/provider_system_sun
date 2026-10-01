import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sun_web_system/features/notifications/data/datasource/parsers/new_service_request_parser/new_service_request_parser.dart';
import 'package:sun_web_system/features/service_requests/data/model/service_request_model.dart';
import 'package:sun_web_system/features/service_requests/data/model/readable_api_text.dart';
import 'package:sun_web_system/features/service_requests/data/repository/service_requests_repository.dart';
import 'package:sun_web_system/features/service_requests/data/request/service_offer_request.dart';
import 'package:sun_web_system/features/service_requests/presentation/cubit/service_requests_cubit.dart';

void main() {
  group('service request payloads', () {
    test('repairs mojibake Arabic without changing correct translations', () {
      final brokenArabic = latin1.decode(utf8.encode('الصيانة والإصلاح'));
      expect(readableApiText(brokenArabic), 'الصيانة والإصلاح');
      expect(readableApiText('الصيانة والإصلاح'), 'الصيانة والإصلاح');
      expect(readableApiText('Maintenance & Repair'), 'Maintenance & Repair');

      final json = _requestJson(id: 15);
      (json['service'] as Map<String, dynamic>)['name'] = brokenArabic;
      expect(
          ServiceRequestModel.fromJson(json).service.name, 'الصيانة والإصلاح');
    });

    test('serializes selected values instead of contract example IDs', () {
      const request = ServiceOfferRequest(
        id: 91,
        serviceRequestId: 81,
        providerId: 71,
        branchId: 61,
        price: 521,
        cost: 321,
        serviceId: 51,
        taxId: 41,
        employeeId: 31,
        providerServiceId: 21,
      );

      expect(request.toCreateJson(), {
        'servicerequestid': 81,
        'provid': 71,
        'branchid': 61,
        'price': 521,
        'cost': 321,
        'serviceid': 51,
        'taxid': 41,
        'employeeid': 31,
        'provserviceid': 21,
      });
      expect(request.toUpdateJson(), {
        'id': 91,
        'price': 521,
        'cost': 321,
        'branchid': 61,
        'serviceid': 51,
        'taxid': 41,
        'employeeid': 31,
        'provserviceid': 21,
      });
    });

    test('parses list/details fields defensively', () {
      final model = ServiceRequestModel.fromJson(_requestJson(id: 3));

      expect(model.id, 3);
      expect(model.price, 300);
      expect(model.user.name, 'omara');
      expect(model.service.id, 6);
      expect(model.car.name, 'سنترا');
      expect(model.appointment, DateTime(2026, 10, 1, 17, 42, 12, 181));
    });

    test('parses SignalR item without another API call', () {
      final parsed = const NewServiceRequestParser().parse([
        {
          'userId': null,
          'userType': 4,
          'data': {
            'title': 'طلب خدمة جديد',
            'body': 'تم إنشاء طلب خدمة جديد.',
            'data': {'serviceId': '6'},
            'item': _requestJson(id: 45),
          },
        }
      ]);

      expect(parsed?.serviceId, 6);
      expect(parsed?.item?.id, 45);
      expect(parsed?.item?.user.name, 'omara');
    });

    test('repairs notification text when the server sends mojibake', () {
      final parsed = const NewServiceRequestParser().parse([
        {
          'userType': 4,
          'data': {
            'title': latin1.decode(utf8.encode('طلب خدمة جديد')),
            'body': latin1.decode(utf8.encode('تم إنشاء طلب خدمة جديد.')),
          },
        }
      ]);

      expect(parsed?.title, 'طلب خدمة جديد');
      expect(parsed?.body, 'تم إنشاء طلب خدمة جديد.');
    });
  });

  group('ServiceRequestsCubit', () {
    test('uses the current provider without a service ID filter', () async {
      final repository = _FakeRepository();
      var currentProviderId = 71;
      final cubit = ServiceRequestsCubit(
        repository: repository,
        providerIdLoader: () async => currentProviderId,
      );

      await cubit.loadRequests();
      expect(repository.lastProviderId, 71);

      currentProviderId = 72;
      await cubit.loadRequests();
      expect(repository.lastProviderId, 72);
      expect(repository.listCalls, 2);
      await cubit.close();
    });

    test('merges realtime requests and only increments badge off-page',
        () async {
      final repository = _FakeRepository(
        requests: [
          ServiceRequestModel.fromJson(_requestJson(id: 1, serviceId: 42)),
        ],
      );
      final cubit = ServiceRequestsCubit(
        repository: repository,
        providerIdLoader: () async => 4,
      );

      await cubit.loadRequests();
      cubit.addRealtimeRequest(
        ServiceRequestModel.fromJson(_requestJson(id: 2, serviceId: 42)),
        pageIsOpen: false,
      );
      cubit.addRealtimeRequest(
        ServiceRequestModel.fromJson(_requestJson(id: 3, serviceId: 42)),
        pageIsOpen: true,
      );

      expect(repository.listCalls, 1);
      expect(cubit.requests.map((item) => item.id), containsAll([1, 2, 3]));
      expect(cubit.unreadCount, 1);
      cubit.markSeen();
      expect(cubit.unreadCount, 0);
      await cubit.close();
    });

    test('shows only offers belonging to the current provider', () async {
      final detailsJson = _requestJson(id: 3)
        ..['offers'] = [
          _offerJson(id: 10, providerId: 4),
          _offerJson(id: 11, providerId: 9),
        ];
      final repository = _FakeRepository(
        details: ServiceRequestModel.fromJson(detailsJson),
      );
      final cubit = ServiceRequestsCubit(
        repository: repository,
        providerIdLoader: () async => 4,
      );

      await cubit.openDetails(3);

      expect(cubit.selectedRequest?.offers, hasLength(1));
      expect(cubit.selectedRequest?.offers.single.id, 10);
      await cubit.close();
    });
  });
}

Map<String, dynamic> _requestJson({required int id, int serviceId = 6}) => {
      'id': id,
      'price': 300,
      'notes': 'string',
      'appointment': '2026-10-01T17:42:12.181',
      'date': '2026-09-19T17:34:47.4808067',
      'lat': 24.71355,
      'long': 46.6753,
      'offersCount': 0,
      'hasMyOffer': false,
      'isRefused': false,
      'user': {
        'userId': 5,
        'userType': 1,
        'userName': 'omara',
        'phone': '0570164944',
        'email': 'omara@gmail.com',
      },
      'service': {
        'id': serviceId,
        'name': 'الصيانة والإصلاح',
        'latinName': 'Maintenance & Repair',
      },
      'car': {
        'id': 12,
        'name': 'سنترا',
        'plateNo': 'دوط ١٢٣٤',
      },
    };

Map<String, dynamic> _offerJson({
  required int id,
  required int providerId,
}) =>
    {
      'id': id,
      'serviceRequestId': 3,
      'offerStatus': 0,
      'cost': 450,
      'price': {
        'price': 600,
        'cost': 450,
        'taxPercentage': 15,
        'taxAmount': 90,
        'totalPrice': 690,
      },
      'provider': {'id': providerId, 'name': 'provider'},
      'branch': {'id': 3, 'name': 'branch', 'latinName': 'branch'},
      'employee': {'id': 1, 'name': 'employee', 'job': 'job'},
      'service': {
        'id': 6,
        'name': 'الصيانة والإصلاح',
        'latinName': 'Maintenance & Repair',
      },
    };

class _FakeRepository implements ServiceRequestsRepository {
  _FakeRepository({this.requests = const [], this.details});

  final List<ServiceRequestModel> requests;
  final ServiceRequestModel? details;
  int listCalls = 0;
  int? lastProviderId;

  @override
  Future<int> createOffer(ServiceOfferRequest request) async => 1;

  @override
  Future<void> deleteOffer(int offerId) async {}

  @override
  Future<ServiceRequestModel> getDetails(int requestId) async => details!;

  @override
  Future<List<ServiceRequestModel>> getRequests({
    required int providerId,
  }) async {
    listCalls++;
    lastProviderId = providerId;
    return requests;
  }

  @override
  Future<String?> refuseRequest({
    required int providerId,
    required int requestId,
  }) async =>
      null;

  @override
  Future<void> updateOffer(ServiceOfferRequest request) async {}
}
