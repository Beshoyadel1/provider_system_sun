import 'package:sun_web_system/features/store_page/data/model/upload_provider_work_times_model/work_time_model.dart';

class ProviderWorkTimeRequest {
  const ProviderWorkTimeRequest({required this.workTime});

  final WorkTimeModel workTime;

  Map<String, dynamic> toJson() => workTime.toJson();
}
