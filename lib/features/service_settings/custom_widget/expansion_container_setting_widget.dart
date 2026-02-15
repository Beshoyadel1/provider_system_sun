import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/animated_cross_fade_in_expansion_container_setting_widget.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/container_open_close_tab_setting.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';

class ExpansionContainerSettingWidget extends StatelessWidget {
  final String imagePath, text;
  final bool? isDoneTask;

  const ExpansionContainerSettingWidget(
      {super.key,
      required this.imagePath,
      required this.text,
      this.isDoneTask = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsContainerSettingCubit(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    spacing: 5,
                    children: [
                      Flexible(
                        child: Opacity(
                            opacity: isDoneTask! ? 1 : 0.5,
                            child: Image.asset(imagePath)),
                      ),
                      TextInAppWidget(
                        text: text,
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                      if (isDoneTask!)
                        Expanded(
                          child: TextInAppWidget(
                            text: AppLanguageKeys.allCategories,
                            textSize: 13,
                            fontWeightIndex:
                                FontSelectionData.regularFontFamily,
                            textColor: AppColors.orangeColor,
                          ),
                        ),
                    ],
                  ),
                ),
                ContainerOpenCloseTabSetting(
                  isDoneTask: isDoneTask,
                )
              ],
            ),
            AnimatedCrossFadeInExpansionContainerSettingWidget()
          ],
        ),
      ),
    );
  }
}
