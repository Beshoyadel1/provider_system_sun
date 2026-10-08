import 'package:flutter/material.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class BranchFilterDropdown extends StatefulWidget {
  const BranchFilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final int value;
  final Map<int, String> items;
  final ValueChanged<int?>? onChanged;

  @override
  State<BranchFilterDropdown> createState() => _BranchFilterDropdownState();
}

class _BranchFilterDropdownState extends State<BranchFilterDropdown> {
  bool _resetScheduled = false;

  void _resetUnavailableSelection() {
    if (_resetScheduled ||
        widget.items.containsKey(widget.value) ||
        widget.onChanged == null) {
      return;
    }
    _resetScheduled = true;
    // Update the actual filter after the frame, rather than during a build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetScheduled = false;
      if (mounted && !widget.items.containsKey(widget.value)) {
        widget.onChanged?.call(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _resetUnavailableSelection();
    final selectedValue =
        widget.items.containsKey(widget.value) ? widget.value : 0;
    final borderRadius = BorderRadius.circular(15);
    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: AppColors.darkColor.withValues(alpha: 0.2),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: widget.label,
          textSize: 11,
          textColor: AppColors.blackColor,
          fontWeightIndex: FontSelectionData.regularFontFamily,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          key: ValueKey(selectedValue),
          initialValue: selectedValue,
          isExpanded: true,
          isDense: true,
          dropdownColor: AppColors.whiteColor,
          borderRadius: borderRadius,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.orangeColor,
            size: 20,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteColor,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(
                color: AppColors.orangeColor,
                width: 1.5,
              ),
            ),
          ),
          items: [
            for (final item in widget.items.entries)
              DropdownMenuItem<int>(
                value: item.key,
                child: TextInAppWidget(
                  text: item.value,
                  textSize: 13,
                  textColor: widget.onChanged == null
                      ? AppColors.darkGreyColor
                      : AppColors.blackColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  isEllipsisTextOverflow: true,
                  maxLines: 1,
                ),
              ),
          ],
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
