import '../../../../../service_requests/data/model/service_request_model.dart';
import '../../../../../service_requests/data/model/readable_api_text.dart';
import '../../../model/new_service_request_notification_model.dart';
import '../root_parser/root_parser.dart';

class NewServiceRequestParser {
  const NewServiceRequestParser({this.rootParser = const RootParser()});

  final RootParser rootParser;

  NewServiceRequestNotificationModel? parse(List<Object?>? arguments) {
    final root = rootParser.parse(arguments);
    if (root == null) return null;

    final envelope = _map(root['data']);
    final compactData = _map(envelope['data']);
    final itemJson = _mapOrNull(envelope['item']);
    final item =
        itemJson == null ? null : ServiceRequestModel.fromJson(itemJson);

    final serviceId = item?.service.id ??
        _int(compactData['serviceId']) ??
        _int(compactData['serviceid']) ??
        0;

    return NewServiceRequestNotificationModel(
      userId: _int(root['userId']),
      userType: _int(root['userType']) ?? 0,
      title: readableApiText(envelope['title'] ?? 'طلب خدمة جديد'),
      body: readableApiText(envelope['body'] ?? 'تم إنشاء طلب خدمة جديد.'),
      serviceId: serviceId,
      item: item,
    );
  }

  static Map<String, dynamic> _map(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : {};
  }

  static Map<String, dynamic>? _mapOrNull(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static int? _int(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
