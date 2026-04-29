import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/store_page/logic/work_time_cubit/work_time_cubit.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../working_hours_widget.dart';
import '../../../logic/work_time_cubit/work_time_state.dart';
import 'package:intl/intl.dart';

class WorkingHoursContent extends StatefulWidget {
  const WorkingHoursContent({super.key});

  @override
  State<WorkingHoursContent> createState() => _WorkingHoursContentState();
}

class _WorkingHoursContentState extends State<WorkingHoursContent> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      UpdateWorkTimeCubit.get(context).getWorkTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateWorkTimeCubit, WorkTimeState>(
      listener: (context, state) {

        if (state is WorkTimeSuccess) {
          AppSnackBar.showSuccess(AppLanguageKeys.success);
        }

        if (state is WorkTimeDeleteSuccess) {
          AppSnackBar.showSuccess(AppLanguageKeys.success);
        }

        if (state is WorkTimeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<UpdateWorkTimeCubit, WorkTimeState>(
        builder: (context, state) {

          final cubit = UpdateWorkTimeCubit.get(context);

          if (state is WorkTimeLoading && cubit.workTimes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.workTimes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),

                itemBuilder: (context, index) {
                  final item = cubit.workTimes[index];

                  final isSelected =
                      cubit.selectedWorkTimeId == item.worktimeid;

                  return CustomContainer(
                    isSelected: isSelected,
                    onTap: (){},
                    border: Border.all(color: AppColors.lightGreyColor),

                    containerColor: isSelected
                        ? AppColors.orangeColor.withOpacity(0.08)
                        : AppColors.whiteColor,

                    textColor: isSelected
                        ? AppColors.orangeColor
                        : AppColors.whiteColor,


                    typeWidget: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// LEFT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              TextInAppWidget(
                                text:
                                "${formatTime(item.fromTime ?? '', context)} - ${formatTime(item.toTime ?? '', context)}",
                                textSize: 18,
                                fontWeightIndex: FontSelectionData.mediumFontFamily,
                                textColor: AppColors.darkColor,
                              ),

                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: List.generate(daysOfWeek.length, (dayIndex) {

                                  bool isDaySelected = false;

                                  if (dayIndex == 0) isDaySelected = item.sat == true;
                                  if (dayIndex == 1) isDaySelected = item.sun == true;
                                  if (dayIndex == 2) isDaySelected = item.mon == true;
                                  if (dayIndex == 3) isDaySelected = item.tue == true;
                                  if (dayIndex == 4) isDaySelected = item.wed == true;
                                  if (dayIndex == 5) isDaySelected = item.thr == true;
                                  if (dayIndex == 6) isDaySelected = item.fri == true;

                                  return CustomContainer(
                                    isSelected: isDaySelected,
                                    onTap: null,
                                    text: daysOfWeek[dayIndex],
                                    containerColor: isDaySelected
                                        ? AppColors.whiteColor
                                        : AppColors.lightGreyColor,
                                    textColor: isDaySelected
                                        ? AppColors.orangeColor
                                        : AppColors.darkGreyColor,
                                    border: isDaySelected
                                        ? Border.all(color: AppColors.orangeColor)
                                        : Border(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        Wrap(
                          spacing: 10,

                          children: [

                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                cubit.selectWorkTime(item);
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cubit.deleteWorkTime(item.worktimeid!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightGreyColor),
                ),
                child: Column(
                  spacing: 10,
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
                      text: AppLanguageKeys.weekDaysKey,
                      textSize: 18,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    const TextInAppWidget(
                      text: AppLanguageKeys.selectWorkDaysKey,
                      textSize: 15,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.darkGreyColor,
                    ),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(daysOfWeek.length, (index) {
                        final isSelected = cubit.selectedDays.contains(index);

                        return CustomContainer(
                          isSelected: isSelected,
                          onTap: () => cubit.toggleDay(index),
                          text: daysOfWeek[index],
                          containerColor: isSelected
                              ? AppColors.whiteColor
                              : AppColors.lightGreyColor,
                          textColor: isSelected
                              ? AppColors.orangeColor
                              : AppColors.darkGreyColor,
                          border: isSelected
                              ? Border.all(color: AppColors.orangeColor)
                              : Border(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        );

                      }),
                    ),

                    const SizedBox(height: 20),

                    const TextInAppWidget(
                      text: AppLanguageKeys.availableTimesKey,
                      textSize: 18,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.darkColor,
                    ),

                    const TextInAppWidget(
                      text: AppLanguageKeys.selectAvailableTimeKey,
                      textSize: 15,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.darkGreyColor,
                    ),

                    const SizedBox(height: 10),

                    const WorkingHoursWidget(),

                    const SizedBox(height: 20),

                    /// ================= BUTTONS =================
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeColor,
                          ),
                          onPressed: cubit.isEditMode
                              ? () => cubit.updateWorkTime(
                              cubit.selectedWorkTimeId!)
                              : cubit.createWorkTime,
                          child: TextInAppWidget(
                            textSize: 13,
                            text: cubit.isEditMode
                                ? AppLanguageKeys.edit
                                : AppLanguageKeys.create,
                            textColor: AppColors.whiteColor,
                          ),
                        ),

                        const SizedBox(width: 10),

                        if (cubit.isEditMode)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orangeColor,
                            ),
                            onPressed: cubit.clearSelection,
                            child: const TextInAppWidget(
                              text: AppLanguageKeys.cancel,
                              textSize: 13,
                              textColor: AppColors.whiteColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String formatTime(String time, BuildContext context) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);

      final locale = Localizations.localeOf(context).languageCode;

      /// format حسب اللغة
      return DateFormat.jm(locale).format(parsedTime);
    } catch (e) {
      return time; // fallback
    }
  }
  final List<String> daysOfWeek = [
    AppLanguageKeys.saturdayKey,
    AppLanguageKeys.sundayKey,
    AppLanguageKeys.mondayKey,
    AppLanguageKeys.tuesdayKey,
    AppLanguageKeys.wednesdayKey,
    AppLanguageKeys.thursdayKey,
    AppLanguageKeys.fridayKey,
  ];
}