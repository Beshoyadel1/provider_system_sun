import 'package:flutter/material.dart';
import 'app_filter_dialog.dart';

class PageSizeFilter extends StatelessWidget {
  const PageSizeFilter(
      {super.key, required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int>? onChanged;
  @override
  Widget build(BuildContext context) => AppFilterDropdown(
        value: value,
        label: Localizations.localeOf(context).languageCode == 'ar'
            ? 'عدد النتائج'
            : 'Results per page',
        items: {
          for (final size in [10, 20, 50]) size: '$size'
        },
        onChanged: onChanged == null
            ? null
            : (size) {
                if (size != null) onChanged!(size);
              },
      );
}
