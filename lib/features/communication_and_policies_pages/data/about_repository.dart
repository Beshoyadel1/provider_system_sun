import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api/dio_function/dio_controller.dart';

class AboutPage {
  AboutPage.fromJson(Map<String, dynamic> json)
      : titleAr = (json['titletext'] as String? ?? '').trim(),
        titleEn = (json['titletexten'] as String? ?? '').trim(),
        contentAr = (json['contenttext'] as String? ?? '').trim(),
        contentEn = (json['contenttexten'] as String? ?? '').trim();
  final String titleAr, titleEn, contentAr, contentEn;
  String title(bool arabic) => _localized(titleAr, titleEn, arabic);
  String content(bool arabic) => _localized(contentAr, contentEn, arabic);
  static String _localized(String ar, String en, bool arabic) {
    final preferred = arabic ? ar : en;
    return preferred.isNotEmpty ? preferred : (arabic ? en : ar);
  }
}

class AboutRepository {
  Future<List<AboutPage>> getPages() async {
    final response = await Network.getData(ApiLink.getAllPagesAbout);
    if (response.statusCode != 200) {
      throw const FormatException('Unable to load About pages');
    }
    return parsePages(response.data);
  }

  static List<AboutPage> parsePages(dynamic body) {
    if (body is! Map || body['success'] != true || body['data'] is! List) {
      throw const FormatException('Invalid About pages response');
    }
    return (body['data'] as List)
        .map((item) =>
            AboutPage.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((page) =>
            page.titleAr.isNotEmpty ||
            page.titleEn.isNotEmpty ||
            page.contentAr.isNotEmpty ||
            page.contentEn.isNotEmpty)
        .toList();
  }
}
