import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/store_page/data/model/upload_provider_work_times_model/work_time_model.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/work_time_cubit/work_time_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/work_time_cubit/work_time_state.dart';

import '../../working_hours_widget.dart';

class WorkingHoursContent extends StatefulWidget {
  const WorkingHoursContent({super.key});

  @override
  State<WorkingHoursContent> createState() => _WorkingHoursContentState();
}

class _WorkingHoursContentState extends State<WorkingHoursContent> {
  bool _isAdding = false;

  final List<String> _daysOfWeek = [
    AppLanguageKeys.saturdayKey,
    AppLanguageKeys.sundayKey,
    AppLanguageKeys.mondayKey,
    AppLanguageKeys.tuesdayKey,
    AppLanguageKeys.wednesdayKey,
    AppLanguageKeys.thursdayKey,
    AppLanguageKeys.fridayKey,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      UpdateWorkTimeCubit.get(context).getWorkTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateWorkTimeCubit, WorkTimeState>(
      listener: (context, state) {
        if (state is WorkTimeSuccess) {
          setState(() => _isAdding = false);
          AppSnackBar.showSuccess(AppLanguageKeys.success);
        } else if (state is WorkTimeDeleteSuccess) {
          setState(() => _isAdding = false);
          AppSnackBar.showSuccess(
            AppLanguageKeys.deleteProviderWorkTimeSuccess,
          );
        } else if (state is WorkTimeError) {
          AppSnackBar.showError(state.message);
        }
      },
      builder: (context, state) {
        final cubit = UpdateWorkTimeCubit.get(context);
        final isLoading = state is WorkTimeLoading;

        if (isLoading && cubit.workTimes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: TextInAppWidget(
                    text: AppLanguageKeys.allWorkingHours,
                    textSize: 18,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    foregroundColor: AppColors.whiteColor,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          cubit.clearSelection();
                          setState(() => _isAdding = true);
                        },
                  icon: const Icon(Icons.add_rounded),
                  label: const TextInAppWidget(
                    text: AppLanguageKeys.addWorkingHours,
                    textSize: 14,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            if (isLoading) const LinearProgressIndicator(),
            if (cubit.workTimes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightGreyColor),
                ),
                child: const TextInAppWidget(
                  text: AppLanguageKeys.addAtLeastOneWorkingHours,
                  textAlign: TextAlign.center,
                  textSize: 15,
                  textColor: AppColors.darkGreyColor,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.workTimes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _WorkTimeListTile(
                    workTime: cubit.workTimes[index],
                    daysOfWeek: _daysOfWeek,
                    isDisabled: isLoading,
                    onEdit: (workTime) {
                      cubit.selectWorkTime(workTime);
                      setState(() => _isAdding = true);
                    },
                    onDelete: cubit.deleteWorkTime,
                  );
                },
              ),
            if (_isAdding) _buildAddForm(cubit, isLoading),
          ],
        );
      },
    );
  }

  Widget _buildAddForm(UpdateWorkTimeCubit cubit, bool isLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Column(
        spacing: 14,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInAppWidget(
            text: cubit.isEditMode
                ? AppLanguageKeys.editWorkingHours
                : AppLanguageKeys.addWorkingHours,
            textSize: 16,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.darkColor,
          ),
          const TextInAppWidget(
            text: AppLanguageKeys.selectWorkDaysKey,
            textSize: 14,
            textColor: AppColors.darkGreyColor,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_daysOfWeek.length, (index) {
              final isSelected = cubit.selectedDays.contains(index);

              return CustomContainer(
                isSelected: isSelected,
                onTap: isLoading ? null : () => cubit.toggleDay(index),
                text: _daysOfWeek[index],
                containerColor: isSelected
                    ? AppColors.whiteColor
                    : AppColors.lightGreyColor,
                textColor: isSelected
                    ? AppColors.orangeColor
                    : AppColors.darkGreyColor,
                border: isSelected
                    ? Border.all(color: AppColors.orangeColor)
                    : const Border(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              );
            }),
          ),
          const TextInAppWidget(
            text: AppLanguageKeys.selectAvailableTimeKey,
            textSize: 14,
            textColor: AppColors.darkGreyColor,
          ),
          WorkingHoursWidget(enabled: !isLoading),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        final workTimeId = cubit.selectedWorkTimeId;
                        if (cubit.isEditMode && workTimeId != null) {
                          cubit.updateWorkTime(workTimeId);
                        } else {
                          cubit.createWorkTime();
                        }
                      },
                child: TextInAppWidget(
                  text: cubit.isEditMode
                      ? AppLanguageKeys.save
                      : AppLanguageKeys.create,
                  textSize: 13,
                  textColor: AppColors.whiteColor,
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        cubit.clearSelection();
                        setState(() => _isAdding = false);
                      },
                child: const TextInAppWidget(
                  text: AppLanguageKeys.cancel,
                  textSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkTimeListTile extends StatelessWidget {
  const _WorkTimeListTile({
    required this.workTime,
    required this.daysOfWeek,
    required this.isDisabled,
    required this.onEdit,
    required this.onDelete,
  });

  final WorkTimeModel workTime;
  final List<String> daysOfWeek;
  final bool isDisabled;
  final ValueChanged<WorkTimeModel> onEdit;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    final selectedDays = _selectedDayIndexes(workTime);
    final workTimeId = workTime.worktimeid;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightGreyColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: const CircleAvatar(
          backgroundColor: AppColors.orangeColor,
          child: Icon(
            Icons.schedule_rounded,
            color: AppColors.whiteColor,
          ),
        ),
        title: TextInAppWidget(
          text:
              '${_formatTime(workTime.fromTime, context)} - ${_formatTime(workTime.toTime, context)}',
          textSize: 16,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.darkColor,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedDays
                .map(
                  (index) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextInAppWidget(
                      text: daysOfWeek[index],
                      textSize: 12,
                      textColor: AppColors.whiteColor,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: AppLocalizations.of(
                context,
              ).translate(AppLanguageKeys.edit),
              onPressed: isDisabled || workTimeId == null
                  ? null
                  : () => onEdit(workTime),
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.orangeColor,
            ),
            IconButton(
              tooltip: AppLocalizations.of(
                context,
              ).translate(AppLanguageKeys.delete),
              onPressed: isDisabled || workTimeId == null
                  ? null
                  : () => onDelete(workTimeId),
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.redColor,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(String? value, BuildContext context) {
    final parts = value?.split(':');
    if (parts == null || parts.length < 2) return value ?? '';

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return value ?? '';

    return TimeOfDay(hour: hour, minute: minute).format(context);
  }

  static List<int> _selectedDayIndexes(WorkTimeModel item) {
    return [
      if (item.sat == true) 0,
      if (item.sun == true) 1,
      if (item.mon == true) 2,
      if (item.tue == true) 3,
      if (item.wed == true) 4,
      if (item.thr == true) 5,
      if (item.fri == true) 6,
    ];
  }
}
