/// Stable identities shared by summary cards, charts and their legend.
class DashboardService {
  const DashboardService(this.id, this.arabic, this.english, this.aliases);
  final int id;
  final String arabic;
  final String english;
  final List<String> aliases;

  static const all = [
    DashboardService(
        1, 'صيانات وخدمات داخلية', 'Maintenance & internal services', [
      'الصيانة والخدمات الداخلية',
      'صيانة وخدمات داخلية',
      'maintenance',
      'internal services'
    ]),
    DashboardService(
        2, 'الخدمات المتنقلة والنقل', 'Mobile services & transport', [
      'الخدمات المتنقلة والنقل',
      'خدمات متنقلة',
      'mobile services',
      'transportation'
    ]),
    DashboardService(3, 'قطع غيار سيارات', 'Car spare parts',
        ['قطع غيار السيارات', 'قطع غيار', 'spare parts']),
    DashboardService(4, 'باقات مشتركة', 'Service packages',
        ['باقات الخدمات', 'الباقات', 'باقات', 'shared packages', 'packages']),
    DashboardService(
        5, 'بترول', 'Petrol', ['البترول', 'الوقود', 'petroleum', 'fuel']),
  ];

  static String normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll(RegExp(r'[^a-z0-9\u0621-\u064A]'), '');

  static int? resolve({int? id, String? arabic, String? english}) {
    if (all.any((service) => service.id == id)) return id;
    final names = [arabic, english]
        .whereType<String>()
        .map(normalize)
        .where((name) => name.isNotEmpty)
        .toSet();
    for (final service in all) {
      if ([service.arabic, service.english, ...service.aliases]
          .map(normalize)
          .any(names.contains)) {
        return service.id;
      }
    }
    return null;
  }
}

double? dashboardNumber(dynamic value) {
  final number = value is num ? value.toDouble() : double.tryParse('$value');
  return number != null && number.isFinite ? number : null;
}

int? dashboardInt(dynamic value) => dashboardNumber(value)?.toInt();
