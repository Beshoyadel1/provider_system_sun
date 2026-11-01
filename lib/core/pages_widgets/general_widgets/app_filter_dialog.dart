import 'package:flutter/material.dart';

import '../../theming/colors.dart';
import '../../theming/fonts.dart';

class AppFilterButton extends StatelessWidget {
  const AppFilterButton(
      {super.key, required this.onPressed, this.activeCount = 0});

  final VoidCallback onPressed;
  final int activeCount;

  @override
  Widget build(BuildContext context) => Badge(
        isLabelVisible: activeCount > 0,
        backgroundColor: AppColors.orangeColor,
        textColor: AppColors.whiteColor,
        label: Text('$activeCount',
            style: const TextStyle(fontFamily: AppFonts.readexProFontFamily)),
        child: IconButton(
          tooltip: Localizations.localeOf(context).languageCode == 'ar'
              ? 'الفلاتر'
              : 'Filters',
          onPressed: onPressed,
          icon: const Icon(Icons.filter_list_rounded, size: 23),
          style: IconButton.styleFrom(
            minimumSize: const Size(46, 46),
            backgroundColor: activeCount > 0
                ? AppColors.orangeColor.withValues(alpha: .08)
                : AppColors.whiteColor,
            foregroundColor: AppColors.orangeColor,
            side: BorderSide(
                color: activeCount > 0
                    ? AppColors.orangeColor
                    : AppColors.cardStroke),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );
}

class AppFilterDialog extends StatelessWidget {
  const AppFilterDialog({
    super.key,
    required this.title,
    required this.child,
    required this.onApply,
    required this.onReset,
    this.canApply = true,
  });

  final String title;
  final Widget child;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final bool canApply;

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.cardStroke),
    );
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme:
            theme.textTheme.apply(fontFamily: AppFonts.readexProFontFamily),
        colorScheme: theme.colorScheme.copyWith(
          primary: AppColors.orangeColor,
          onPrimary: AppColors.whiteColor,
          surface: AppColors.whiteColor,
          onSurface: AppColors.darkColor,
          surfaceTint: AppColors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.scaffoldColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide:
                const BorderSide(color: AppColors.orangeColor, width: 1.5),
          ),
          labelStyle:
              const TextStyle(color: AppColors.darkGreyColor, fontSize: 14),
          floatingLabelStyle: const TextStyle(color: AppColors.orangeColor),
        ),
      ),
      child: AlertDialog(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardStroke),
        ),
        titlePadding: const EdgeInsets.fromLTRB(22, 20, 14, 0),
        contentPadding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
        actionsPadding: const EdgeInsets.fromLTRB(22, 6, 22, 22),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.orangeColor.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.filter_list_rounded,
                color: AppColors.orangeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontFamily: AppFonts.readexProFontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkColor)),
          ),
          IconButton(
            tooltip: ar ? 'إغلاق' : 'Close',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: AppColors.darkGreyColor,
          ),
        ]),
        content: SizedBox(
          width: 440,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .55),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                      key: const Key('filter-reset'),
                      onPressed: onReset,
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      label: Text(ar ? 'إعادة تعيين' : 'Reset'),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.darkGreyColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  child,
                ],
              ),
            ),
          ),
        ),
        actions: [
          Row(children: [
            Expanded(
              child: OutlinedButton(
                key: const Key('filter-cancel'),
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkGreyColor,
                  side: const BorderSide(color: AppColors.cardStroke),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle:
                      const TextStyle(fontFamily: AppFonts.readexProFontFamily),
                ),
                child: Text(ar ? 'إلغاء' : 'Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                key: const Key('filter-apply'),
                onPressed: canApply ? onApply : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  foregroundColor: AppColors.whiteColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontFamily: AppFonts.readexProFontFamily,
                      fontWeight: FontWeight.w600),
                ),
                child: Text(ar ? 'تطبيق الفلاتر' : 'Apply filters'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class AppFilterDropdown extends StatelessWidget {
  const AppFilterDropdown(
      {super.key,
      required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  final String label;
  final int value;
  final Map<int, String> items;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<int>(
        key: ValueKey('$label-$value-${onChanged == null}'),
        initialValue: value,
        isExpanded: true,
        dropdownColor: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            color: AppColors.orangeColor),
        decoration: InputDecoration(labelText: label),
        items: [
          for (final item in items.entries)
            DropdownMenuItem(
                value: item.key,
                child: Text(item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontFamily: AppFonts.readexProFontFamily,
                        fontSize: 14))),
        ],
        onChanged: onChanged,
      );
}
