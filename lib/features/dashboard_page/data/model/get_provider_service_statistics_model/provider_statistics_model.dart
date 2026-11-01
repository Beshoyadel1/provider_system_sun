import 'package:sun_web_system/core/api/api_json.dart';
import 'summary_card.dart';

class ProviderStatisticsModel {
  final List<SummaryCard> summaryCards;

  ProviderStatisticsModel({
    required this.summaryCards,
  });

  factory ProviderStatisticsModel.fromJson(
      Map<String, dynamic> json) {
    json = ApiJson.object(json);

    final data = json['data'];

    return ProviderStatisticsModel(
      summaryCards: (data['summaryCards'] as List<dynamic>)
          .map((e) => SummaryCard.fromJson(e))
          .toList(),
    );
  }
}
